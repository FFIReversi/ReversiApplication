import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:reversi/reversi.dart';

import '../Widgets/board.dart';
import 'boardPage.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  String roomID = "";
  var _roomInputController = TextEditingController();
  late WebSocket webSocket;
  int _lastPosition = -1;
  List<int> _chessBoard = List<int>.filled(64, 0);
  int _player = 0;
  int _nowPlayer = 0;
  bool _isGameEnd = false;
  bool _isWebSocketConnected = false;
  String _waiting = "";
  List<List<int>> _chessBoardHistory = [];
  List<int> _playerHistory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chessBoard[27] = 1;
    _chessBoard[28] = 2;
    _chessBoard[35] = 2;
    _chessBoard[36] = 1;
  }

  void _joinRoom() async {
    try {
      webSocket = await WebSocket.connect("ws://pal222.tplinkdns.com:8765/");
      roomID = _roomInputController.text;
      webSocket.add('{"room_id":"$roomID"}');
      _isGameEnd = false;
      webSocket.listen((data) {
        print(data);
        var json = jsonDecode(data);
        _handleWebSocketError(json);
        _webSocketListener(json);
      });
      webSocket.done.then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("WebSocket connection closed")));
        _waiting = "";
        _gameEnd();
        _isWebSocketConnected = false;
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("WebSocket connection closed abnormally: $error")));
        _waiting = "";
        _gameEnd();
        _isWebSocketConnected = false;
        setState(() {});
      });
      _isWebSocketConnected = true;

      Timer(Duration(milliseconds: 100), () {
        setState(() {});
      });
    } catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $ex")));
    }
  }

  void _handleWebSocketError(var json) {
    if (json["status"] == "error" || json["status"] == "room_full") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${json["message"]}")));
    }
    if (json["status"] == "room_full") {
      roomID = "";
      setState(() {});
    }
  }

  void _webSocketListener(var json) {
    var data = json["data"];
    if (json["status"] == "player_left") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${json["message"]}")));
    }
    try {
      if (json["status"] == "room_created" || json["status"] == "room_joined") {
        _player = data["player_number"];
      }

      if (data["current_players_count"] == 1) {
        if (json["status"] != "room_created") {
          _gameEnd();
        }
        _waiting = "Waiting for opponent...";
      } else {
        _waiting = "";
        if (json["status"] == "player_joined" ||
            json["status"] == "room_joined") {
          print("ss");
          _startGame(data);
        }
      }
      setState(() {});
    } catch (ex) {
      print(ex);
    }
    try {
      List<int> chessBoard = [];
      for (int element in data["Board"]) {
        chessBoard.add(element);
      }
      _chessBoard = chessBoard;
      if (!data["DoNotMove"]) {
        _nowPlayer = _player;
      }
      if (data["IsEnd"]) {
        _gameEnd();
      }
      setState(() {});
      var blackMovable = getMovableArray(_player, _chessBoard);
      for (var m in blackMovable) {
        _chessBoard[m.y * 8 + m.x] = 3;
      }
      setState(() {});
    } catch (ex) {
      print(ex);
    }
  }

  void _switchPlayer() {
    if (_nowPlayer == Player.black.index) {
      _nowPlayer = Player.white.index;
    } else {
      _nowPlayer = Player.black.index;
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _gameEnd() {
    _playerHistory.add(_nowPlayer);
    _isGameEnd = true;
    setState(() {});
  }

  void _moveChess(int chessPosition) {
    Coordinates dropPoint = Coordinates()
      ..y = chessPosition ~/ 8
      ..x = chessPosition % 8;

    _clearFlippedState(true);
    _chessBoard = makeMove(_player, _chessBoard, dropPoint);
    _switchPlayer();

    var movable = getMovableArray(_nowPlayer, _chessBoard);
    if (movable.isEmpty) {
      _switchPlayer();
      movable = getMovableArray(_nowPlayer, _chessBoard);

      if (movable.isEmpty) {
        _clearFlippedState(true);
        webSocket.add(jsonEncode({
          "room_id": roomID,
          "Board": _chessBoard,
          "IsEnd": true,
          "DoNotMove": false,
        }));
        _gameEnd();
      } else {
        webSocket.add(jsonEncode({
          "room_id": roomID,
          "Board": _chessBoard,
          "IsEnd": true,
          "DoNotMove": true,
        }));
        for (var m in movable) {
          _chessBoard[m.y * 8 + m.x] = 3;
        }
      }
    } else {
      _clearFlippedState(true);
      webSocket.add(jsonEncode({
        "room_id": roomID,
        "Board": _chessBoard,
        "IsEnd": false,
        "DoNotMove": false,
      }));
    }

    setState(() {});
  }

  void _startGame(var data) {
    if (_player == 1) {
      var blackMovable = getMovableArray(_player, _chessBoard);
      for (var m in blackMovable) {
        _chessBoard[m.y * 8 + m.x] = 3;
      }
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

  @override
  Widget build(BuildContext context) {
    double sizeOfBoard = MediaQuery.sizeOf(context).width * (3 / 5) >
            MediaQuery.sizeOf(context).height
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width * (3 / 5);
    if (roomID.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Room ID:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _roomInputController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorScheme.of(context).primary, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorScheme.of(context).primary, width: 1.0),
                    ),
                    hintText: 'Room ID',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_roomInputController.text.isNotEmpty) {
                        _joinRoom();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Room ID cannot be empty"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"),
                                    )
                                  ]);
                            });
                      }

                      setState(() {});
                    },
                    child: Text("Join / Create"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back"),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
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
                      webSocket.close();
                      roomID = "";
                      _isGameEnd = false;
                      setState(() {});
                    },
                    heroTag: null,
                    child: const Icon(Symbols.signal_disconnected_rounded),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    webSocket.close();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
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
                                  aiPosition: _lastPosition,
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
                                          if (_nowPlayer ==
                                              Player.black.index) {
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
                                    Icon(Icons.home, size: 25),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(
                                          softWrap: true,
                                          "Room ID: $roomID",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
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
                                        borderRadius:
                                            BorderRadius.circular(360),
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
                          if (_waiting.isNotEmpty)
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
                                        child: CircularProgressIndicator(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          _waiting,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                                Player.black
                                                                    .index)
                                                            .length >
                                                        _chessBoard
                                                            .where((element) =>
                                                                element ==
                                                                Player.white
                                                                    .index)
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
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Colors.black,
                                                      Colors.white
                                                    ]),
                                                color: _chessBoard
                                                            .where((element) =>
                                                                element ==
                                                                Player.black
                                                                    .index)
                                                            .length >
                                                        _chessBoard
                                                            .where((element) =>
                                                                element ==
                                                                Player.white
                                                                    .index)
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
                                          webSocket.close();
                                        },
                                        icon: Icon(Icons.arrow_back),
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
      ),
    );
  }
}
