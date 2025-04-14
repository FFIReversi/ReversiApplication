import 'dart:io';

import 'package:flutter/material.dart';

import 'boardPage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reversi Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Reversi!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the game page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardPage(gameMode: 0),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the game page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardPage(gameMode: 1),
                  ),
                );
              },
              child: const Text('Start Game vs AI level 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the game page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardPage(gameMode: 2),
                  ),
                );
              },
              child: const Text('Start Game vs AI level 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the game page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardPage(gameMode: 3),
                  ),
                );
              },
              child: const Text('Start Game vs AI level 3'),
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
    );
  }
}
