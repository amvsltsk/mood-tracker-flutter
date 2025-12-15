import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String mood; // Emoji або короткий код

  @HiveField(2)
  String content;

  Note({
    required this.date,
    required this.mood,
    required this.content,
  });
}
