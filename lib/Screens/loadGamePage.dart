import 'package:flutter/material.dart';
import 'package:reversi_application/Screens/previousBoardPage.dart';

import '../Utils/database.dart';
import '../Utils/game.dart';
import 'boardPage.dart';

class LoadGamePage extends StatefulWidget {
  const LoadGamePage({super.key});

  @override
  State<LoadGamePage> createState() => _LoadGamePageState();
}

class _LoadGamePageState extends State<LoadGamePage> {
  var previousGames = List<Game>.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGames();
  }

  void _loadGames() async {
    if (previousGames.isNotEmpty) {
      previousGames.clear();
    }
    previousGames = await DBHelper().getAll();
    for (var i in previousGames) {
      print(i.id);
    }
    setState(() {});
  }

  PageRouteBuilder _changePageRoute(Widget newPage) {
    int animationDuration = 150;
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            newPage,
        transitionDuration: Duration(milliseconds: animationDuration),
        reverseTransitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 從右進來
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.linear));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0), // 從下方輕微滑入
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Previous Games",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      // alignment: WrapAlignment.center,
                      children: previousGames.map((e) {
                        var dateTime = DateTime.parse(e.dateTime);
                        return Container(
                          width: 350,
                          // height: 150,
                          decoration: BoxDecoration(
                            color: ColorScheme.of(context).onSecondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: DefaultTextStyle(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${dateTime.year} / ${dateTime.month} / ${dateTime.day}",
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dateTime.hour}:${dateTime.minute}:${dateTime.second}.${dateTime.millisecond}",
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 15,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                  color: Colors.black,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(150),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(3, 3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Text(
                                                  "${e.chessBoard.last.where((element) => element == Player.black.index).length}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(150),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(3, 3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Text(
                                                  "${e.chessBoard.last.where((element) => element == Player.white.index).length}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                _changePageRoute(
                                                    PreviousBoardPage(
                                                        info: e)));
                                          },
                                          icon: Icon(
                                            Icons.arrow_circle_right_outlined,
                                            size: 30,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await DBHelper.isar.writeTxn(() =>
                                                DBHelper.isar.games
                                                    .delete(e.id));
                                            _loadGames();
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
