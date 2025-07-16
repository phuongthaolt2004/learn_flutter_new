import 'package:hive/hive.dart';


part 'todo.g.dart'; // <- Đoạn này báo Flutter biết sẽ sinh file này


@HiveType(typeId: 0)
class Todo extends HiveObject {
 @HiveField(0)
 String title;


 @HiveField(1)
 String description;


 @HiveField(2)
 DateTime deadline;


 @HiveField(3)
 bool isDone;


 Todo({
   required this.title,
   required this.description,
   required this.deadline,
   this.isDone = false,
 });
}
