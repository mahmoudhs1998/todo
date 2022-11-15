class TodoModel
{
  final int? id;
  final String title;
final int isDone;
final int taskID;
  TodoModel({
    this.id,
    required this.title,
    required this.isDone,
    required this.taskID,

  });

  Map<String,dynamic> toMap()
  {
    return
      {
        'id':id,
        'title':title,
        'isDone':isDone,
        'taskID':taskID,
      };
  }
}