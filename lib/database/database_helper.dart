import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/todo_model.dart';

class DatabaseHelper
{
  Future<Database> dataBase()async
  {
return openDatabase(
  join(await getDatabasesPath(), 'todo.db'),
  onCreate: (db, version) async {
    // Run the CREATE TABLE statement on the database.
    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
    );
    await db.execute(
      'CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, isDone INTEGER, taskID INTEGER)',
    );

  },
  version: 1,

);

  }

  Future<int> insertTasks(TaskModel task)async
  {
    int taskId = 0;
    Database _db = await dataBase();
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)
    .then((value)
    {
      taskId = value;
    }).catchError((error)
    {
      print('error = === = >>>> ${error.toString()}');
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id , String title) async
  {
    Database _db = await dataBase();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");

  }
  Future<void> updateTaskDescription(int id , String description) async
  {
    Database _db = await dataBase();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");

  }

  Future<void> updateTodoDone(int id , int isDone) async
  {
    Database _db = await dataBase();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");

  }

  Future<void> insertTodo(TodoModel todo)async
  {
    Database _db = await dataBase();
    await _db.insert('todo', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TaskModel>> getTasks()async
  {
    Database _db = await dataBase();
    List<Map<String,dynamic>> tasksMap = await _db.query('tasks');
    return List.generate(tasksMap.length, (index)
    => TaskModel(
        id: tasksMap[index]['id'],
        title: tasksMap[index]['title'],
        description:tasksMap[index]['description']
    ),
    );
  }


  Future<List<TodoModel>> getTodo(int taskID)async
  {
    Database _db = await dataBase();
    List<Map<String,dynamic>> todoMap = await _db.rawQuery('SELECT * FROM todo WHERE taskID = $taskID');
    return List.generate(todoMap.length, (index)
    => TodoModel(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskID:todoMap[index]['taskID'],
      isDone: todoMap[index]['isDone'],
    ),
    );
  }


  Future<void> deleteTodo(int id ) async
  {
    Database _db = await dataBase();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE id = '$id'");

  }


}