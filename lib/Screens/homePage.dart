import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reversi_application/Screens/loadGamePage.dart';
import 'package:reversi_application/Screens/networkPage.dart';

import 'boardPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "images/home_page_chess_board.png",
                width: (MediaQuery.sizeOf(context).width >
                            MediaQuery.sizeOf(context).height
                        ? MediaQuery.sizeOf(context).width
                        : MediaQuery.sizeOf(context).height) *
                    0.6,
                alignment: Alignment.bottomRight,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  ColorScheme.of(context).surface,
                  Color(0xD000000)
                ]),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome to Reversi !',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(context,
                              _changePageRoute(BoardPage(gameMode: 0)));
                        },
                        child: const Text('Start Game (Player vs Player)'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(context,
                              _changePageRoute(BoardPage(gameMode: 1)));
                        },
                        child: const Text('Start Game (Player vs AI level 1)'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(context,
                              _changePageRoute(BoardPage(gameMode: 2)));
                        },
                        child: const Text('Start Game (Player vs AI level 2)'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(context,
                              _changePageRoute(BoardPage(gameMode: 3)));
                        },
                        child: const Text('Start Game (Player vs AI level 3'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(
                              context, _changePageRoute(NetworkPage()));
                        },
                        child: const Text('Online mode'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(
                              context, _changePageRoute(LoadGamePage()));
                        },
                        child: const Text('Previous Games'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => exit(0)),
                          );
                        },
                        child: const Text('Exit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
