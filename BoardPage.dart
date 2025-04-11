import 'package:flutter/material.dart';
import 'reversi.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // 棋盘数据 0: 空位, 1: 黑棋, 2: 白棋
  List<int> _board = List.filled(64, 0);

  // 当前玩家 0: 黑棋, 1: 白棋
  int _currentPlayer = 0;

  // 棋盘初始化
  @override
  void initState() {super.initState();_board[27] = 1;_board[28] = 2;_board[35] = 2;_board[36] = 1;}

  // 棋子显示 根据棋盘数据返回对应的棋子图标
  Widget _getPiece(int value) {
    // 可落子位置顯示
    if (getMovableArray(_currentPlayer % 2 + 1,_board,).any((point) => point.y == value % 8 && point.x == value ~/ 8)) {
      return Icon(Icons.circle,color: const Color.fromARGB(255, 252, 255, 59),size: 20,);
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
      backgroundColor: const Color.fromARGB(255, 104, 66, 34),

      // 设置标题栏
      appBar: AppBar(
        title:_currentPlayer % 2 == 0?
          Text('Reversi    now Player: Black'):
          Text('Reversi    now Player: White',),
      ),

      body: Padding(
        // 设置棋盘位置
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: SizedBox(
          // 设置棋盘大小
          width: 600,
          height: 600,

          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: 64,
            itemBuilder: (BuildContext context, int index) {
              // 计算行和列
              int row = index % 8;
              int col = index ~/ 8;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    // 计算点击的行和列
                    Coordinates dropPoint = Coordinates() ..y = index ~/ 8  ..x = index % 8;

                    // 獲取可落子位置
                    List<Coordinates> movablePoints = getMovableArray(_currentPlayer % 2 + 1,_board,);

                    // 如果没有可落子位置，切換玩家
                    if (movablePoints.isEmpty) {_currentPlayer++;}

                    // 检查点击的点是否在可落子位置中
                    else if (movablePoints.any((point) => point.y == index % 8 && point.x == index ~/ 8,)) {
                      _board = makeMove(_currentPlayer % 2 + 1,_board,dropPoint,);
                      _currentPlayer++;
                    }

                    //檢查棋局使否結束
                    if (_board.every((value) => value != 0) ||_board.every((value) => value != 1) ||_board.every((value) => value != 2) ||getMovableArray(1, _board).isEmpty &&getMovableArray(2, _board).isEmpty) {
                      // 计算黑棋和白棋的数量
                      int blackCount =_board.where((value) => value == 1).length;
                      int whiteCount =_board.where((value) => value == 2).length;

                      // 显示游戏结束对话框
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Game Over'),
                            content:
                                blackCount > whiteCount? Text('Black wins!\nblack: $blackCount, white: $whiteCount',style: TextStyle(fontSize: 20),):
                                blackCount < whiteCount? Text('White wins!\nblack: $blackCount, white: $whiteCount',style: TextStyle(fontSize: 20),):
                                const Text('Draw!'),

                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {Navigator.of(context).pop();},
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                },
                //棋盤
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 136, 57),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 1,
                    ),
                    borderRadius:
                        row == 0 && col == 0? BorderRadius.only(topLeft: Radius.circular(10)):
                        row == 0 && col == 7? BorderRadius.only(bottomLeft: Radius.circular(10)):
                        row == 7 && col == 0? BorderRadius.only(topRight: Radius.circular(10)):
                        row == 7 && col == 7? BorderRadius.only(bottomRight: Radius.circular(10),): null,
                  ),

                  //生成棋子
                  child: Align(
                    alignment: Alignment.center, // 确保棋子居中
                    child: _getPiece(index), // 添加棋子
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}