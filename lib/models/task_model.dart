


class TaskModel
{
   final int? id;
  final String title;
  final String description;
  TaskModel({
     this.id,
    required this.title,
    required this.description,

});

  Map<String,dynamic> toMap()
  {
    return
      {
        'id':id,
        'title':title,
        'description':description,
      };
  }

}