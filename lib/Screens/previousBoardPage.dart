import 'dart:ui';

import 'package:flutter/material.dart';

import '../Utils/game.dart';
import '../Widgets/board.dart';
import 'boardPage.dart';

class PreviousBoardPage extends StatefulWidget {
  Game info;

  PreviousBoardPage({
    super.key,
    required this.info,
  });

  @override
  State<PreviousBoardPage> createState() => _PreviousBoardPageState();
}

class _PreviousBoardPageState extends State<PreviousBoardPage> {
  int _nowPlayer = Player.black.index;
  bool _isGameEnd = false;
  int _nowIndex = 0;
  late var _chessBoardOfInfo = widget.info.chessBoard.toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<int> _chessBoard = List<int>.filled(64, 0);
    _chessBoard = List<int>.filled(64, 0);
    _chessBoard[27] = 1;
    _chessBoard[28] = 2;
    _chessBoard[35] = 2;
    _chessBoard[36] = 1;
    _chessBoardOfInfo.insert(0, _chessBoard);
    print(_chessBoardOfInfo.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeOfBoard = MediaQuery.sizeOf(context).width * (3 / 5) >
            MediaQuery.sizeOf(context).height
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width * (3 / 5);
    return Scaffold(
        body: Stack(
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
                    _nowIndex = 0;
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                  heroTag: null,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
                heroTag: null,
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
                                board: _chessBoardOfInfo[_nowIndex],
                                onPress: (int index) {
                                  return;
                                },
                                onHover: (int index) {
                                  return;
                                },
                                onHoverOut: (int index) {
                                  return;
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
                                      borderRadius: BorderRadius.circular(360),
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(150),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      "${_chessBoardOfInfo[_nowIndex].where((element) => element == Player.black.index || (Player.black.index != _nowPlayer && element == 4)).length}",
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(150),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      "${_chessBoardOfInfo[_nowIndex].where((element) => element == Player.white.index || (Player.white.index != _nowPlayer && element == 4)).length}",
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xff3a4b3a),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        if (_nowIndex > 0) {
                                          _nowIndex--;
                                          _nowPlayer =
                                              widget.info.player[_nowIndex];
                                        }
                                        setState(() {});
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_back_outlined,size: 35,),
                                            Text("Back"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 30,
                                      width: 2,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withAlpha(100),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        if (_nowIndex + 1 < _chessBoardOfInfo.length) {
                                          _nowIndex++;
                                          _nowPlayer = widget.info.player[_nowIndex];
                                        } else {
                                          _isGameEnd = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_forward,size: 35,),
                                          Text("Forward"),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
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
              color: Color(0xD5000000),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
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
                                            "* ${_chessBoardOfInfo[_nowIndex].where((element) => element == Player.black.index).length}",
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
                                            "* ${_chessBoardOfInfo[_nowIndex].where((element) => element == Player.white.index).length}",
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
                                    _chessBoardOfInfo[_nowIndex]
                                                .where((element) =>
                                                    element ==
                                                    Player.black.index)
                                                .length !=
                                            _chessBoardOfInfo[_nowIndex]
                                                .where((element) =>
                                                    element ==
                                                    Player.white.index)
                                                .length
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _chessBoardOfInfo[
                                                              _nowIndex]
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .black.index)
                                                          .length >
                                                      _chessBoardOfInfo[
                                                              _nowIndex]
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
                                              color: _chessBoardOfInfo[
                                                              _nowIndex]
                                                          .where((element) =>
                                                              element ==
                                                              Player
                                                                  .black.index)
                                                          .length >
                                                      _chessBoardOfInfo[
                                                              _nowIndex]
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
                                        _nowIndex = 0;
                                        _isGameEnd = false;
                                        setState(() {});
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
    ));
  }
}
