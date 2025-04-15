import 'dart:convert';

import 'package:hive/hive.dart';
import 'game.dart';

class DBHelper {
  void save(List<int> players, List<List<int>> chessBoard) async {
    var box = Hive.box("Reversi");
    Game record = Game(
      dateTime: DateTime.now().toString(),
      player: players,
      chessBoard: chessBoard,
    );
    box.add(record);
  }

  Future<List<Game>> getAll() async {
    var box = Hive.box("Reversi");

    var resultList = box.keys.map((e) {
      var tisElement = box.get(e) as Game;
      return Game(
        id: e as int,
        dateTime: tisElement.dateTime,
        player: tisElement.player,
        chessBoard: tisElement.chessBoard,
      );
    }).toList();

    return resultList;
  }

}
