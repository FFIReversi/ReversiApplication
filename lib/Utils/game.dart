import 'package:isar/isar.dart';

part 'game.g.dart';

@collection
@Name("Game")
class Game {
  @Name("dateTime")
  String dateTime;
  @Name("player")
  List<int> player;
  @Name("chessBoardJson")
  String chessBoardJson = "";

  @ignore
  List<List<int>> chessBoard = List.empty(growable: true);
  Id id = Isar.autoIncrement;

  Game({
    this.id = Isar.autoIncrement,
    List<List<int>>? chessBoard,
    this.chessBoardJson = "",
    required this.dateTime,
    required this.player,
  }) {
    this.chessBoard = chessBoard ?? [];
  }
}
