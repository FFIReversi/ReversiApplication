import 'package:flutter/material.dart';

import '../Screens/boardPage.dart';

class Board extends StatefulWidget {
  List<int> board;
  int nowPlayer;
  int aiPosition;

  final void Function(int index) onPress;
  final void Function(int index) onHover;
  final void Function(int index) onHoverOut;

  Board(
      {super.key,
      required this.board,
      required this.nowPlayer,
      required this.aiPosition,
      required this.onPress,
      required this.onHover,
      required this.onHoverOut});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  List<double> _scaleList = List<double>.filled(64, 1);
  late AnimationController _controller;
  late Animation<double> _paddingAnimation;
  static const List<Color> _chessColor = [
    Colors.transparent,
    Colors.black,
    Colors.white,
    Color(0xC0FFFFFF)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(microseconds: 800),
    )..repeat(reverse: true);

    _paddingAnimation = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> _board = widget.board;
    double _padding =
        MediaQuery.sizeOf(context).width < MediaQuery.sizeOf(context).height
            ? MediaQuery.sizeOf(context).width * 0.05
            : MediaQuery.sizeOf(context).height * 0.05;
    if (_board.isEmpty) {
      return Container();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade900,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'images/wood.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.black, width: 0.75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'images/noisy.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: 64,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          widget.onPress(index);
                        },
                        onHover: (value) {
                          widget.onHover(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: MouseRegion(
                            onEnter: (value) {
                              // if (_board[index] == 1 || _board[index] == 2) {
                              //   _scaleList[index] = 1.1;
                              // }
                              // if (_board[index] == 3) {
                              //   _scaleList[index] = 1.3;
                              // }
                              _scaleList[index] = 1.2;
                              setState(() {});
                            },
                            onExit: (value) {
                              if (_scaleList[index] != 1.0) {
                                _scaleList[index] = 1.0;
                              }
                              widget.onHoverOut(index);
                              setState(() {});
                            },
                            child: Transform.scale(
                              scale: _scaleList[index],
                              child: Padding(
                                padding: _board[index] == 3
                                    ? const EdgeInsets.all(23)
                                    : const EdgeInsets.all(7),
                                child: Stack(
                                  children: [
                                    index == widget.aiPosition
                                        ? Center(
                                            child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          365),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.amber
                                                          .withAlpha((100 *
                                                                      _paddingAnimation
                                                                          .value /
                                                                      6)
                                                                  .ceil() +
                                                              50),
                                                      // ,
                                                      spreadRadius:
                                                          _paddingAnimation
                                                              .value,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 0),
                                                    )
                                                  ],
                                                  color: Colors.transparent,
                                                )),
                                          )
                                        : SizedBox(),
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: _chessColor[_board[index] == 4
                                            ? widget.nowPlayer ==
                                                    Player.white.index
                                                ? Player.black.index
                                                : Player.white.index
                                            : _board[index]],
                                        boxShadow: [
                                          if (_board[index] != 0)
                                            BoxShadow(
                                              color: Colors.black.withAlpha((150 -
                                                      (index ==
                                                              widget.aiPosition
                                                          ? 150 *
                                                              (_paddingAnimation
                                                                      .value /
                                                                  6)
                                                          : 1))
                                                  .ceil()),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(3, 3),
                                            ),
                                        ],
                                      ),
                                    ),
                                    _board[index] == 4
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
