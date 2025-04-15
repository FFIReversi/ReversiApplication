import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject{
  @HiveField(0)
  String dateTime;
  @HiveField(1)
  List<int> player;
  @HiveField(2)
  List<List<int>> chessBoard;

  int id = 0;

  Game({
    this.id = 0 ,
    required this.dateTime,
    required this.player,
    required this.chessBoard,
  });
}