import 'dart:async';
import 'package:flutter/material.dart';
import 'reversi.dart';

class BoardPage extends StatefulWidget {
  final int choose;

  const BoardPage({super.key, required this.choose});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // 棋盘数据 0: 空位, 1: 黑棋, 2: 白棋
  List<int> _board = List.filled(64, 0);
  List<int> preview = List.filled(64, 0);
  List<int> move_recode = [];
  List<int> player_recode = [];

  // 当前玩家 0: 黑棋, 1: 白棋
  int _currentPlayer = 0;

  int time = 0;

  late int choose;

  // 初始化
  @override
  void initState() {
    super.initState();
    choose = widget.choose;
    _board[27] = 1;
    _board[28] = 2;
    _board[35] = 2;
    _board[36] = 1;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      return setState(() {
        time++;
        if (time >= 60) {
          time = 0;
          _currentPlayer++;
          preview = List.filled(64, 0);
        }
      });
    });
  }

  // 棋子显示 根据棋盘数据返回对应的棋子图标
  Widget _getPiece(int value) {
    if (preview[value] == 3) {
      return Icon(
        Icons.circle,
        color: const Color.fromARGB(255, 255, 72, 59),
        size: 40,
      );
    }
    // 可落子位置顯示
    if (getMovableArray(
      _currentPlayer % 2 + 1,
      _board,
    ).any((point) => point.y == value % 8 && point.x == value ~/ 8)) {
      return Icon(
        Icons.circle,
        color: const Color.fromARGB(255, 252, 255, 59),
        size: 20,
      );
    }
    // 黑棋顯示
    else if (_board[value] == 1) {
      return Icon(Icons.circle, color: Colors.black, size: 40);
    }
    // 白棋顯示
    else if (_board[value] == 2) {
      return Icon(Icons.circle, color: Colors.white, size: 40);
    }
    // 空位顯示
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 设置背景颜色
      backgroundColor: const Color.fromARGB(255, 139, 94, 57),

      // 设置标题栏
      appBar: AppBar(
        title:
            _currentPlayer % 2 == 0
                ? Text('Reversi\tnow Player: 黑色')
                : Text('Reversi\tnow Player: 白色'),
      ),

      body: Row(
        children: [
          Expanded(
            child: Padding(
              // 设置棋盘位置
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: SizedBox(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (BuildContext context, int index) {
                    // 计算行和列
                    int row = index % 8;
                    int col = index ~/ 8;

                    return MouseRegion(
                      onEnter:
                          (event) => setState(() {
                            Coordinates dropPoint =
                                Coordinates()
                                  ..y = index ~/ 8
                                  ..x = index % 8;
                            List<int> tempBoard = makeMove(
                              _currentPlayer % 2 + 1,
                              _board,
                              dropPoint,
                            );
                            preview = List.generate(
                              tempBoard.length,
                              (index) => tempBoard[index] - _board[index],
                            );
                            for (int i = 0; i < preview.length; i++)
                              if (_board[i] != 0 && preview[i] != 0)
                                preview[i] = 3;
                            // 鼠标悬停时的处理逻辑
                          }),
                      onExit:
                          (event) => setState(() {
                            // 鼠标离开时的处理逻辑
                            preview = List.filled(64, 0);
                          }),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            time = 0;
                            preview = List.filled(64, 0);
                            // 计算点击的行和列
                            Coordinates dropPoint =
                                Coordinates()
                                  ..y = index ~/ 8
                                  ..x = index % 8;

                            // 獲取可落子位置
                            List<Coordinates> movablePoints = getMovableArray(
                              _currentPlayer % 2 + 1,
                              _board,
                            );

                            // 如果没有可落子位置，切換玩家
                            if (movablePoints.isEmpty) {
                              _currentPlayer++;
                            }
                            // 检查点击的点是否在可落子位置中
                            else if (movablePoints.any(
                              (point) =>
                                  point.y == index % 8 && point.x == index ~/ 8,
                            )) {
                              if (choose == 0) {
                                player_recode.add(_currentPlayer);
                                move_recode.add(index);
                                _board = makeMove(
                                  _currentPlayer % 2 + 1,
                                  _board,
                                  dropPoint,
                                );
                                _currentPlayer++;
                              } else if (choose != 0 &&
                                  _currentPlayer % 2 + 1 == 1) {
                                player_recode.add(_currentPlayer);
                                move_recode.add(index);
                                _board = makeMove(
                                  _currentPlayer % 2 + 1,
                                  _board,
                                  dropPoint,
                                );
                                _currentPlayer++;
                              }
                              ;
                            } else if (choose == 1 &&
                                _currentPlayer % 2 + 1 == 2) {
                              _board = aiRandom(_currentPlayer % 2 + 1, _board);
                              _currentPlayer++;
                            } else if (choose == 2 &&
                                _currentPlayer % 2 + 1 == 2) {
                              _board = aiGreedy(_currentPlayer % 2 + 1, _board);
                              _currentPlayer++;
                            } else if (choose == 3 &&
                                _currentPlayer % 2 + 1 == 2) {
                              _board = aiGreedyAlphaBeta(
                                _currentPlayer % 2 + 1,
                                _board,
                              );
                              _currentPlayer++;
                            }

                            //檢查棋局使否結束
                            if (_board.every((value) => value != 0) ||
                                _board.every((value) => value != 1) ||
                                _board.every((value) => value != 2) ||
                                getMovableArray(1, _board).isEmpty &&
                                    getMovableArray(2, _board).isEmpty) {
                              // 计算黑棋和白棋的数量
                              int blackCount =
                                  _board.where((value) => value == 1).length;
                              int whiteCount =
                                  _board.where((value) => value == 2).length;

                              // 显示游戏结束对话框
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Game Over'),
                                    content:
                                        blackCount > whiteCount
                                            ? Text(
                                              'Black wins!  black: $blackCount, white: $whiteCount',
                                            )
                                            : blackCount < whiteCount
                                            ? Text(
                                              'White wins!  black: $blackCount, white: $whiteCount',
                                            )
                                            : const Text('Draw!'),

                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        },

                        child: SizedBox(
                          height: 50,
                          child: Container(
                            //棋盤外觀
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 136, 57),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 1,
                              ),
                              borderRadius:
                                  row == 0 && col == 0
                                      ? BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      )
                                      : row == 0 && col == 7
                                      ? BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      )
                                      : row == 7 && col == 0
                                      ? BorderRadius.only(
                                        topRight: Radius.circular(10),
                                      )
                                      : row == 7 && col == 7
                                      ? BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                      )
                                      : null,
                            ),

                            //生成棋子
                            child: Align(
                              alignment: Alignment.center, // 确保棋子居中
                              child: _getPiece(index), // 添加棋子
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    move_recode.isNotEmpty
                        ? _currentPlayer % 2 + 1 == 1
                            ? 'black : ${move_recode.last % 8 + 1} , ${move_recode.last ~/ 8 + 1}'
                            : 'white: ${move_recode.last % 8 + 1} , ${move_recode.last ~/ 8 + 1}'
                        : ' ',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  'Histroy',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                height: 200,
                child: ListView.builder(
                  itemCount: move_recode.length,
                  itemBuilder: (context, index) {
                    int value = move_recode[move_recode.length - 1 - index];
                    int y = value % 8 + 1; // row
                    int x = value ~/ 8 + 1; // column
                    int player =
                        player_recode[move_recode.length - 1 - index] % 2 +
                        1; // player
                    return Text(
                      '${player == 1 ? "black" : "white"}: ($y, $x)',
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
              ),

              Expanded(child: Container()),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 130,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '60 / $time',
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
