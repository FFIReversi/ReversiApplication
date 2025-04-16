import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'game.dart';

class DBHelper {
  static late final Isar isar;

  static Future<void> setup() async {
    isar = await Isar.open(
      [GameSchema],
      inspector: true,
      directory: (await getApplicationDocumentsDirectory()).path,
    );
  }

  void save(List<int> players, List<List<int>> chessBoard) async {
    Game record = Game(
      dateTime: DateTime.now().toString(),
      player: players,
      chessBoardJson: jsonEncode(chessBoard),
    );

    await isar.writeTxn(() => isar.games.put(record));
  }

  Future<List<Game>> getAll() async {
    var resultList = (await isar.games.where().findAll()).map((e) {
      List<List<int>> chessBoard = [];
      for (List<dynamic> element in jsonDecode(e.chessBoardJson)) {
        if (element.isNotEmpty) {
          chessBoard.add(element.cast<int>());
        }
      }
      // print(chessBoard.last);
      return Game(
        id: e.id,
        dateTime: e.dateTime,
        player: e.player,
        chessBoard: chessBoard,
      );
    }).toList();

    return resultList;
  }
}
