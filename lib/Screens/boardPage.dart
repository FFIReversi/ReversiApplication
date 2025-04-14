import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reversi/reversi.dart';
import 'package:reversi_application/Widgets/board.dart';

class BoardPage extends StatefulWidget {
  var gameMode;

  BoardPage({super.key, required this.gameMode});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

enum Player { none, black, white, possible, canBeFlipped }

class _BoardPageState extends State<BoardPage> {
  late var gameMode = widget.gameMode;
  List<int> _chessBoard = List<int>.filled(64, 0);
  int _nowPlayer = Player.black.index;
  bool _isGameEnd = false;

  void _gameEnd() {
    print("SS");
    _isGameEnd = true;
    setState(() {});
  }

  void _switchPlayer() {
    if (_nowPlayer == Player.black.index) {
      _nowPlayer = Player.white.index;
    } else {
      _nowPlayer = Player.black.index;
    }
  }

  void _clearFlippedState() {
    for (int i = 0; i < _chessBoard.length; i++) {
      if (_chessBoard[i] == 4) {
        if (_nowPlayer == Player.black.index) {
          _chessBoard[i] = Player.white.index;
        } else {
          _chessBoard[i] = Player.black.index;
        }
      }
    }
    setState(() {});
  }

  void _handleGameAfterAI() {
    _switchPlayer();

    for (int i = 0; i < _chessBoard.length; i++) {
      if (_chessBoard[i] == 3 || _chessBoard[i] == 4) _chessBoard[i] = 0;
    }

    var movable = getMovableArray(_nowPlayer, _chessBoard);
    if (movable.isEmpty) {
      _switchPlayer();
      movable = getMovableArray(_nowPlayer, _chessBoard);
      if (movable.isEmpty) {
        _gameEnd();
        return;
      }
      if (gameMode == 1) {
        _chessBoard = aiRandom(_nowPlayer, _chessBoard);
      } else if (gameMode == 2) {
        _chessBoard = aiGreedy(_nowPlayer, _chessBoard);
      } else if (gameMode == 3) {
        _chessBoard = aiGreedyAlphaBeta(_nowPlayer, _chessBoard);
      }

      _handleGameAfterAI();
      return;
    } else {
      for (var m in movable) {
        _chessBoard[m.y * 8 + m.x] = 3;
      }
    }
    setState(() {});
  }

  void _moveChess(int chessPosition) {
    Coordinates dropPoint = Coordinates()
      ..y = chessPosition ~/ 8
      ..x = chessPosition % 8;

    for (int i = 0; i < _chessBoard.length; i++) {
      if (_chessBoard[i] == 3 || _chessBoard[i] == 4) _chessBoard[i] = 0;
    }

    _chessBoard = makeMove(_nowPlayer, _chessBoard, dropPoint);

    _switchPlayer();
    if (gameMode == 1) {
      _chessBoard = aiRandom(_nowPlayer, _chessBoard);
      _handleGameAfterAI();
    } else if (gameMode == 2) {
      _chessBoard = aiGreedy(_nowPlayer, _chessBoard);
      _handleGameAfterAI();
    } else if (gameMode == 3) {
      _chessBoard = aiGreedyAlphaBeta(_nowPlayer, _chessBoard);
      _handleGameAfterAI();
    } else {
      var movable = getMovableArray(_nowPlayer, _chessBoard);
      for (var m in movable) {
        _chessBoard[m.y * 8 + m.x] = 3;
      }
      if (movable.isEmpty) {
        _switchPlayer();
        movable = getMovableArray(_nowPlayer, _chessBoard);
        for (var m in movable) {
          _chessBoard[m.y * 8 + m.x] = 3;
        }
        if (movable.isEmpty) {
          _gameEnd();
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chessBoard[27] = 1;
    _chessBoard[28] = 2;
    _chessBoard[35] = 2;
    _chessBoard[36] = 1;
    var blackMovable = getMovableArray(Player.black.index, _chessBoard);
    for (var m in blackMovable) {
      _chessBoard[m.y * 8 + m.x] = 3;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeOfBoard = MediaQuery.sizeOf(context).width * (3 / 5) >
            MediaQuery.sizeOf(context).height
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width * (3 / 5);
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _chessBoard = List<int>.filled(64, 0);
                    _chessBoard[27] = 1;
                    _chessBoard[28] = 2;
                    _chessBoard[35] = 2;
                    _chessBoard[36] = 1;
                    var blackMovable =
                        getMovableArray(Player.black.index, _chessBoard);
                    for (var m in blackMovable) {
                      _chessBoard[m.y * 8 + m.x] = 3;
                    }
                    _nowPlayer = Player.black.index;
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: sizeOfBoard,
                        height: sizeOfBoard,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Board(
                                nowPlayer: _nowPlayer,
                                board: _chessBoard,
                                onPress: (int index) {
                                  _clearFlippedState();
                                  setState(() {});
                                  if (_chessBoard[index] == 3) {
                                    _moveChess(index);
                                    setState(() {});
                                  }
                                },
                                onHover: (int index) {
                                  _clearFlippedState();
                                  setState(() {});
                                  if (_chessBoard[index] == 3) {
                                    Coordinates findPoint = Coordinates()
                                      ..y = index ~/ 8
                                      ..x = index % 8;

                                    var tmp = List<int>.from(_chessBoard);
                                    for (int i = 0; i < tmp.length; i++) {
                                      if (tmp[i] == 3) {
                                        tmp[i] = 0;
                                      }
                                      if (tmp[i] == 4) {
                                        if (_nowPlayer == Player.black.index) {
                                          tmp[i] = Player.white.index;
                                        } else {
                                          tmp[i] = Player.black.index;
                                        }
                                      }
                                    }
                                    var canFlipped = getAllCanFlipped(
                                        _nowPlayer, tmp, findPoint);
                                    for (var m in canFlipped) {
                                      _chessBoard[m.y * 8 + m.x] = 4;
                                    }
                                    setState(() {});
                                  }
                                },
                                onHoverOut: (int index) {
                                  _clearFlippedState();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 10, right: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_nowPlayer == Player.black.index) {
                                _nowPlayer = Player.white.index;
                              } else {
                                _nowPlayer = Player.black.index;
                              }
                              setState(() {});
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  color: Color(0xff3a4b3a),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _nowPlayer == Player.black.index
                                        ? Colors.amber.shade800
                                        : Colors.transparent,
                                    width: 5,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Text(
                                        "${_chessBoard.where((element) => element == Player.black.index || (Player.black.index != _nowPlayer && element == 4)).length}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                                color: Color(0xff3a4b3a),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _nowPlayer == Player.white.index
                                      ? Colors.amber.shade800
                                      : Colors.transparent,
                                  width: 5,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      "${_chessBoard.where((element) => element == Player.white.index || (Player.white.index != _nowPlayer && element == 4)).length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (_isGameEnd)
          AbsorbPointer(
            absorbing: false,
            child: Container(
              color: Color(0xA8000000),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    decoration: TextDecoration.none,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Game End",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              decoration: TextDecoration.none),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff3a4b3a),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(360),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "* ${_chessBoard.where((element) => element == Player.black.index).length}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(360),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "* ${_chessBoard.where((element) => element == Player.white.index).length}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff3a4b3a),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    _chessBoard
                                                .where((element) =>
                                                    element ==
                                                    Player.black.index)
                                                .length !=
                                            _chessBoard
                                                .where((element) =>
                                                    element ==
                                                    Player.white.index)
                                                .length
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _chessBoard
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .black.index)
                                                          .length >
                                                      _chessBoard
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .white.index)
                                                          .length
                                                  ? Colors.black
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                            ),
                                          )
                                        : Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.black,
                                                Colors.black,
                                                Colors.white
                                              ]),
                                              color: _chessBoard
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .black.index)
                                                          .length >
                                                      _chessBoard
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .white.index)
                                                          .length
                                                  ? Colors.black
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Win !!!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xff3a4b3a),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.arrow_back),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _chessBoard = List<int>.filled(64, 0);
                                        _chessBoard[27] = 1;
                                        _chessBoard[28] = 2;
                                        _chessBoard[35] = 2;
                                        _chessBoard[36] = 1;
                                        var blackMovable = getMovableArray(
                                            Player.black.index, _chessBoard);
                                        for (var m in blackMovable) {
                                          _chessBoard[m.y * 8 + m.x] = 3;
                                        }
                                        _nowPlayer = Player.black.index;
                                        setState(() {});
                                        _isGameEnd = false;
                                      },
                                      icon: Icon(Icons.refresh),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
