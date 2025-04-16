// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:reversi/reversi.dart';
// import 'package:reversi_application/Utils/database.dart';
// import 'package:reversi_application/Widgets/board.dart';
//
// class BoardPage extends StatefulWidget {
//   var gameMode;
//
//   BoardPage({super.key, required this.gameMode});
//
//   @override
//   State<BoardPage> createState() => _BoardPageState();
// }
//
// enum Player { none, black, white, possible, canBeFlipped }
//
// class _BoardPageState extends State<BoardPage> {
//   late var gameMode = widget.gameMode;
//   List<int> _chessBoard = List<int>.filled(64, 0);
//   int _nowPlayer = Player.black.index;
//   bool _isGameEnd = false;
//   int _time = 60;
//   List<List<int>> _chessBoardHistory = [];
//   List<int> _playerHistory = [];
//   int _aiPosition = -1;
//
//   late Timer timer;
//
//   void _gameEnd() {
//     _playerHistory.add(_nowPlayer);
//     _isGameEnd = true;
//     setState(() {});
//   }
//
//   bool _listEquals(List<int> a, List<int> b) {
//     if (a.length != b.length) return false;
//     for (int i = 0; i < a.length; i++) {
//       if (a[i] != b[i]) return false;
//     }
//     return true;
//   }
//
//   void _saveGame() {
//     _clearFlippedState(true);
//
//     bool have = false;
//     for (int i = 0; i < _chessBoardHistory.length; i++) {
//       if (_listEquals(_chessBoardHistory[i], _playerHistory)) have = false;
//     }
//
//     if (!have) {
//       print(_chessBoardHistory.where((e) {
//         return e != 0;
//       }).length);
//       _playerHistory.add(_nowPlayer);
//       _chessBoardHistory.add(_chessBoard.toList());
//       // print(_nowPlayer);
//     }
//   }
//
//   void _switchPlayer() {
//     _time = 60;
//     if (_nowPlayer == Player.black.index) {
//       _nowPlayer = Player.white.index;
//     } else {
//       _nowPlayer = Player.black.index;
//     }
//   }
//
//   void _clearFlippedState(bool clean3) {
//     for (int i = 0; i < _chessBoard.length; i++) {
//       if (clean3) {
//         if (_chessBoard[i] == 3) _chessBoard[i] = 0;
//       }
//       if (_chessBoard[i] == 4) {
//         if (_nowPlayer == Player.black.index) {
//           _chessBoard[i] = Player.white.index;
//         } else {
//           _chessBoard[i] = Player.black.index;
//         }
//       }
//     }
//     setState(() {});
//   }
//
//   void _ai(bool needHandle) {
//     _aiPosition = -1;
//     setState(() {});
//     timer = Timer(const Duration(milliseconds: 700), () {
//       var previousBoard = _chessBoard.toList();
//       bool _isSameList = true;
//       if (gameMode == 1) {
//         _isSameList =
//             _listEquals(aiRandom(_nowPlayer, _chessBoard), _chessBoard);
//         _chessBoard = aiRandom(_nowPlayer, _chessBoard);
//       } else if (gameMode == 2) {
//         _isSameList =
//             _listEquals(aiGreedy(_nowPlayer, _chessBoard), _chessBoard);
//         _chessBoard = aiGreedy(_nowPlayer, _chessBoard);
//       } else if (gameMode == 3) {
//         _isSameList = _listEquals(
//             aiGreedyAlphaBeta(_nowPlayer, _chessBoard), _chessBoard);
//         _chessBoard = aiGreedyAlphaBeta(_nowPlayer, _chessBoard);
//       }
//       for (int i = 0; i < _chessBoard.length; i++) {
//         if (previousBoard[i] == 0 && _chessBoard[i] != 0) {
//           _aiPosition = i;
//           setState(() {});
//         }
//       }
//       if (!_isSameList) {
//         _saveGame();
//       }
//       if (needHandle) {
//         _handleGameAfterAI();
//       }
//     });
//   }
//
//   void _handleGameAfterAI() {
//     _clearFlippedState(true);
//     _switchPlayer();
//
//     var movable = getMovableArray(_nowPlayer, _chessBoard);
//     if (movable.isEmpty) {
//       _switchPlayer();
//       movable = getMovableArray(_nowPlayer, _chessBoard);
//       if (movable.isEmpty) {
//         _gameEnd();
//         return;
//       }
//       if (gameMode >= 1 && gameMode <= 3) {
//         _ai(false);
//       } else {
//         for (var m in movable) {
//           _chessBoard[m.y * 8 + m.x] = 3;
//         }
//         return;
//       }
//       _handleGameAfterAI();
//       return;
//     } else {
//       for (var m in movable) {
//         _chessBoard[m.y * 8 + m.x] = 3;
//       }
//     }
//     setState(() {});
//   }
//
//   void _moveChess(int chessPosition) {
//     Coordinates dropPoint = Coordinates()
//       ..y = chessPosition ~/ 8
//       ..x = chessPosition % 8;
//
//     _clearFlippedState(true);
//     _chessBoard = makeMove(_nowPlayer, _chessBoard, dropPoint);
//     _saveGame();
//     _switchPlayer();
//     if (gameMode >= 1 && gameMode <= 3) {
//       _ai(true);
//       // _handleGameAfterAI();
//     } else {
//       var movable = getMovableArray(_nowPlayer, _chessBoard);
//       for (var m in movable) {
//         _chessBoard[m.y * 8 + m.x] = 3;
//       }
//       if (movable.isEmpty) {
//         _switchPlayer();
//         movable = getMovableArray(_nowPlayer, _chessBoard);
//         for (var m in movable) {
//           _chessBoard[m.y * 8 + m.x] = 3;
//         }
//         if (movable.isEmpty) {
//           _gameEnd();
//         }
//       }
//     }
//
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _chessBoard[27] = 1;
//     _chessBoard[28] = 2;
//     _chessBoard[35] = 2;
//     _chessBoard[36] = 1;
//     var blackMovable = getMovableArray(Player.black.index, _chessBoard);
//     for (var m in blackMovable) {
//       _chessBoard[m.y * 8 + m.x] = 3;
//     }
//     _playerHistory.clear();
//     _chessBoardHistory.clear();
//     timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
//       if (!mounted || _isGameEnd) return;
//       _time--;
//       setState(() {});
//       if (_time <= 0) {
//         _clearFlippedState(true);
//         bool _isSameList = true;
//
//         var previousBoard = _chessBoard.toList();
//         _isSameList =
//             _listEquals(aiRandom(_nowPlayer, _chessBoard), _chessBoard);
//         _chessBoard = aiRandom(_nowPlayer, _chessBoard);
//
//         for (int i = 0; i < _chessBoard.length; i++) {
//           if (previousBoard[i] == 0 && _chessBoard[i] != 0) {
//             _aiPosition = i;
//             setState(() {});
//           }
//         }
//         if (!_isSameList) {
//           _saveGame();
//         }
//         _switchPlayer();
//         if (gameMode >= 1 && gameMode <= 3) {
//           _ai(true);
//           // _handleGameAfterAI();
//         } else {
//           _switchPlayer();
//           _handleGameAfterAI();
//         }
//         setState(() {});
//         _time = 60;
//       }
//     });
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     if (timer.isActive) timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double sizeOfBoard = MediaQuery.sizeOf(context).width * (3 / 5) >
//             MediaQuery.sizeOf(context).height
//         ? MediaQuery.sizeOf(context).height
//         : MediaQuery.sizeOf(context).width * (3 / 5);
//     return Stack(
//       children: [
//         Scaffold(
//           floatingActionButton: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     _chessBoard = List<int>.filled(64, 0);
//                     _chessBoard[27] = 1;
//                     _chessBoard[28] = 2;
//                     _chessBoard[35] = 2;
//                     _chessBoard[36] = 1;
//                     var blackMovable =
//                         getMovableArray(Player.black.index, _chessBoard);
//                     for (var m in blackMovable) {
//                       _chessBoard[m.y * 8 + m.x] = 3;
//                     }
//                     _nowPlayer = Player.black.index;
//                     _aiPosition = -1;
//                     _time = 60;
//                     setState(() {});
//                   },
//                   child: Icon(Icons.refresh),
//                   heroTag: null,
//                 ),
//               ),
//               FloatingActionButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(Icons.arrow_back),
//                 heroTag: null,
//               ),
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: sizeOfBoard,
//                         height: sizeOfBoard,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Board(
//                                 nowPlayer: _nowPlayer,
//                                 aiPosition: _aiPosition,
//                                 board: _chessBoard,
//                                 onPress: (int index) {
//                                   _clearFlippedState(false);
//                                   setState(() {});
//                                   if (_chessBoard[index] == 3) {
//                                     _moveChess(index);
//                                     setState(() {});
//                                   }
//                                 },
//                                 onHover: (int index) {
//                                   _clearFlippedState(false);
//                                   setState(() {});
//                                   if (_chessBoard[index] == 3) {
//                                     Coordinates findPoint = Coordinates()
//                                       ..y = index ~/ 8
//                                       ..x = index % 8;
//
//                                     var tmp = List<int>.from(_chessBoard);
//                                     for (int i = 0; i < tmp.length; i++) {
//                                       if (tmp[i] == 3) {
//                                         tmp[i] = 0;
//                                       }
//                                       if (tmp[i] == 4) {
//                                         if (_nowPlayer == Player.black.index) {
//                                           tmp[i] = Player.white.index;
//                                         } else {
//                                           tmp[i] = Player.black.index;
//                                         }
//                                       }
//                                     }
//                                     var canFlipped = getAllCanFlipped(
//                                         _nowPlayer, tmp, findPoint);
//                                     for (var m in canFlipped) {
//                                       _chessBoard[m.y * 8 + m.x] = 4;
//                                     }
//                                     setState(() {});
//                                   }
//                                 },
//                                 onHoverOut: (int index) {
//                                   _clearFlippedState(false);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(top: 20.0, left: 10, right: 30),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: AnimatedContainer(
//                             duration: Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff3a4b3a),
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(
//                                   color: _nowPlayer == Player.black.index
//                                       ? Colors.amber.shade800
//                                       : Colors.transparent,
//                                   width: 5,
//                                 )),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 25,
//                                     height: 25,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(360),
//                                       color: Colors.black,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withAlpha(150),
//                                           spreadRadius: 2,
//                                           blurRadius: 5,
//                                           offset: Offset(3, 3),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5.0),
//                                     child: Text(
//                                       "${_chessBoard.where((element) => element == Player.black.index || (Player.black.index != _nowPlayer && element == 4)).length}",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: AnimatedContainer(
//                             duration: Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff3a4b3a),
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(
//                                   color: _nowPlayer == Player.white.index
//                                       ? Colors.amber.shade800
//                                       : Colors.transparent,
//                                   width: 5,
//                                 )),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 25,
//                                     height: 25,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(360),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withAlpha(150),
//                                           spreadRadius: 2,
//                                           blurRadius: 5,
//                                           offset: Offset(3, 3),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5.0),
//                                     child: Text(
//                                       "${_chessBoard.where((element) => element == Player.white.index || (Player.white.index != _nowPlayer && element == 4)).length}",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: AnimatedContainer(
//                             duration: Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff3a4b3a),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.timer,
//                                     size: 30,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5.0),
//                                     child: Text(
//                                       "${_time}",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         if (_isGameEnd)
//           AbsorbPointer(
//             absorbing: false,
//             child: Container(
//               color: Color(0xD5000000),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                   sigmaX: 10,
//                   sigmaY: 10,
//                 ),
//                 child: DefaultTextStyle(
//                   style: TextStyle(
//                     decoration: TextDecoration.none,
//                   ),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       spacing: 10,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Game End",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 40,
//                               decoration: TextDecoration.none),
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           spacing: 20,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Color(0xff3a4b3a),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   spacing: 10,
//                                   children: [
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Container(
//                                           width: 40,
//                                           height: 40,
//                                           decoration: BoxDecoration(
//                                             color: Colors.black,
//                                             borderRadius:
//                                                 BorderRadius.circular(360),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "* ${_chessBoard.where((element) => element == Player.black.index).length}",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 20,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Container(
//                                           width: 40,
//                                           height: 40,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(360),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "* ${_chessBoard.where((element) => element == Player.white.index).length}",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 20,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Color(0xff3a4b3a),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   spacing: 10,
//                                   children: [
//                                     _chessBoard
//                                                 .where((element) =>
//                                                     element ==
//                                                     Player.black.index)
//                                                 .length !=
//                                             _chessBoard
//                                                 .where((element) =>
//                                                     element ==
//                                                     Player.white.index)
//                                                 .length
//                                         ? Container(
//                                             width: 40,
//                                             height: 40,
//                                             decoration: BoxDecoration(
//                                               color: _chessBoard
//                                                           .where((element) =>
//                                                               element ==
//                                                               Player
//                                                                   .black.index)
//                                                           .length >
//                                                       _chessBoard
//                                                           .where((element) =>
//                                                               element ==
//                                                               Player
//                                                                   .white.index)
//                                                           .length
//                                                   ? Colors.black
//                                                   : Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(360),
//                                             ),
//                                           )
//                                         : Container(
//                                             width: 40,
//                                             height: 40,
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(colors: [
//                                                 Colors.black,
//                                                 Colors.black,
//                                                 Colors.white
//                                               ]),
//                                               color: _chessBoard
//                                                           .where((element) =>
//                                                               element ==
//                                                               Player
//                                                                   .black.index)
//                                                           .length >
//                                                       _chessBoard
//                                                           .where((element) =>
//                                                               element ==
//                                                               Player
//                                                                   .white.index)
//                                                           .length
//                                                   ? Colors.black
//                                                   : Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(360),
//                                             ),
//                                           ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Win !!!",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xff3a4b3a),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               spacing: 10,
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       icon: Icon(Icons.arrow_back),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         _chessBoard = List<int>.filled(64, 0);
//                                         _chessBoard[27] = 1;
//                                         _chessBoard[28] = 2;
//                                         _chessBoard[35] = 2;
//                                         _chessBoard[36] = 1;
//                                         var blackMovable = getMovableArray(
//                                             Player.black.index, _chessBoard);
//                                         for (var m in blackMovable) {
//                                           _chessBoard[m.y * 8 + m.x] = 3;
//                                         }
//                                         _nowPlayer = Player.black.index;
//                                         _isGameEnd = false;
//                                         _time = 60;
//                                         _playerHistory.clear();
//                                         _chessBoardHistory.clear();
//                                         _aiPosition = -1;
//                                         setState(() {});
//                                       },
//                                       icon: Icon(Icons.refresh),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         DBHelper().save(
//                                             _playerHistory, _chessBoardHistory);
//                                       },
//                                       icon: Icon(Icons.save),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reversi/reversi.dart';
import 'package:reversi_application/Utils/database.dart';
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
  int _time = 60;
  List<List<int>> _chessBoardHistory = [];
  List<int> _playerHistory = [];
  int _aiPosition = -1;

  late Timer timer;

  void _gameEnd() {
    _playerHistory.add(_nowPlayer);
    _isGameEnd = true;
    setState(() {});
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _saveGame() {
    _clearFlippedState(true);

    bool have = false;
    for (int i = 0; i < _chessBoardHistory.length; i++) {
      if (_listEquals(_chessBoardHistory[i], _playerHistory)) have = false;
    }

    if (!have) {
      print(_chessBoardHistory.where((e) {
        return e != 0;
      }).length);
      _playerHistory.add(_nowPlayer);
      _chessBoardHistory.add(_chessBoard.toList());
      // print(_nowPlayer);
    }
  }

  void _switchPlayer() {
    _time = 60;
    if (_nowPlayer == Player.black.index) {
      _nowPlayer = Player.white.index;
    } else {
      _nowPlayer = Player.black.index;
    }
  }

  void _clearFlippedState(bool clean3) {
    for (int i = 0; i < _chessBoard.length; i++) {
      if (clean3) {
        if (_chessBoard[i] == 3) _chessBoard[i] = 0;
      }
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

  void _ai(bool needHandle) {
    _aiPosition = -1;
    setState(() {});
    timer = Timer(const Duration(milliseconds: 700), () {
      var previousBoard = _chessBoard.toList();
      bool _isSameList = true;
      if (gameMode == 1) {
        _isSameList =
            _listEquals(aiRandom(_nowPlayer, _chessBoard), _chessBoard);
        _chessBoard = aiRandom(_nowPlayer, _chessBoard);
      } else if (gameMode == 2) {
        _isSameList =
            _listEquals(aiGreedy(_nowPlayer, _chessBoard), _chessBoard);
        _chessBoard = aiGreedy(_nowPlayer, _chessBoard);
      } else if (gameMode == 3) {
        _isSameList = _listEquals(
            aiGreedyAlphaBeta(_nowPlayer, _chessBoard), _chessBoard);
        _chessBoard = aiGreedyAlphaBeta(_nowPlayer, _chessBoard);
      }
      for (int i = 0; i < _chessBoard.length; i++) {
        if (previousBoard[i] == 0 && _chessBoard[i] != 0) {
          _aiPosition = i;
          setState(() {});
        }
      }
      if (!_isSameList) {
        _saveGame();
      }
      if (needHandle) {
        _handleGameAfterAI();
      }
    });
  }

  void _handleGameAfterAI() {
    _clearFlippedState(true);
    _switchPlayer();

    var movable = getMovableArray(_nowPlayer, _chessBoard);
    if (movable.isEmpty) {
      _switchPlayer();
      movable = getMovableArray(_nowPlayer, _chessBoard);
      if (movable.isEmpty) {
        _gameEnd();
        return;
      }
      if (gameMode >= 1 && gameMode <= 3) {
        _ai(true);
      } else {
        for (var m in movable) {
          _chessBoard[m.y * 8 + m.x] = 3;
        }
        return;
      }
      // _handleGameAfterAI();
      // return;
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

    _clearFlippedState(true);
    _chessBoard = makeMove(_nowPlayer, _chessBoard, dropPoint);
    _saveGame();
    _switchPlayer();
    if (gameMode >= 1 && gameMode <= 3) {
      _ai(true);
      // _handleGameAfterAI();
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
    _playerHistory.clear();
    _chessBoardHistory.clear();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isGameEnd) return;
      _time--;
      setState(() {});
      if (_time <= 0) {
        _clearFlippedState(true);
        bool _isSameList = true;

        var previousBoard = _chessBoard.toList();
        _isSameList =
            _listEquals(aiRandom(_nowPlayer, _chessBoard), _chessBoard);
        _chessBoard = aiRandom(_nowPlayer, _chessBoard);

        for (int i = 0; i < _chessBoard.length; i++) {
          if (previousBoard[i] == 0 && _chessBoard[i] != 0) {
            _aiPosition = i;
            setState(() {});
          }
        }
        if (!_isSameList) {
          _saveGame();
        }
        _switchPlayer();
        if (gameMode >= 1 && gameMode <= 3) {
          _ai(true);
        } else {
          _switchPlayer();
          _handleGameAfterAI();
        }
        setState(() {});
        _time = 60;
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer.isActive) timer.cancel();
    super.dispose();
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
                    _aiPosition = -1;
                    _time = 60;
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
                                aiPosition: _aiPosition,
                                board: _chessBoard,
                                onPress: (int index) {
                                  _clearFlippedState(false);
                                  setState(() {});
                                  if (_chessBoard[index] == 3) {
                                    _moveChess(index);
                                    setState(() {});
                                  }
                                },
                                onHover: (int index) {
                                  _clearFlippedState(false);
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
                                  _clearFlippedState(false);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                                color: Color(0xff3a4b3a),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      "${_time}",
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
                                        _isGameEnd = false;
                                        _time = 60;
                                        _playerHistory.clear();
                                        _chessBoardHistory.clear();
                                        _aiPosition = -1;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.refresh),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        DBHelper().save(
                                            _playerHistory, _chessBoardHistory);
                                      },
                                      icon: Icon(Icons.save),
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
