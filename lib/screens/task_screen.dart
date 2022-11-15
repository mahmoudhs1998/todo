import 'package:flutter/material.dart';
import 'package:todo_app/database/database_helper.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/todo_widget.dart';

class TaskPage extends StatefulWidget {
  final TaskModel? task;
  final int? id;
   const TaskPage({Key? key, this.task , this.id }) : super(key: key);



  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool isDone = false;
   String _taskTitle = '';
  String _taskDesc = '';
   int _taskID = 0;
   bool _contentVisiblity= false;

    FocusNode? _titleFocus;
    FocusNode? _descriptionFocus;
    FocusNode? _todoFocus;
@override
  void initState() {
  if(widget.task !=null)
  {
    _contentVisiblity = true;
    _taskTitle = widget.task!.title;
    _taskDesc =  widget.task!.description;
    _taskID = widget.task!.id!;

  }
  _titleFocus = FocusNode();
  _descriptionFocus = FocusNode();
  _todoFocus = FocusNode();

    super.initState();
  }
  @override
  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _todoFocus!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [

              Column(
                children: [


                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,bottom: 6,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: IconButton(
                            onPressed: ()
                            {
                              Navigator.pop(context);
                            },
                            icon:const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),

                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async
                            {
                              await insertData(value);
                              debugPrint("value : $value");
                              _descriptionFocus!.requestFocus();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold
                            ),
                            controller: TextEditingController()..text = _taskTitle,

                          ),
                        ),

                      ],

                    ),

                  ),


                  Visibility(
                    visible: _contentVisiblity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: TextField(
                        controller: TextEditingController()..text = _taskDesc,
                        onSubmitted: (value) async
                        {
                          if(value.isNotEmpty)
                          {
                            if(_taskID != 0)
                            {
                              await _dbHelper.updateTaskDescription(_taskID, value);
                              _taskDesc = value;

                            }
                          }
                          _todoFocus!.requestFocus();
                        },
                        focusNode: _descriptionFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter Description for Task.....',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                        ),

                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisiblity,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: ()
                            {
                              setState(() {
                                isDone = !isDone;
                              });


                            },
                            icon:isDone ?  const Icon(
                              Icons.check_box,
                              color:Colors.grey,
                            ):
                            const Icon(
                              Icons.check_box,
                              color:Colors.deepPurple,
                            )



                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _todoFocus,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Enter Todo Item....',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) async
                            {
                              if(value.isNotEmpty)
                              {
                                if(_taskID !=0)
                                {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  TodoModel _newTodo = TodoModel(
                                    // id: int.parse(value),
                                    taskID: _taskID,
                                    title: value,
                                    isDone: 0,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  print('create new todo');
                                }else{print('updated');}

                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  ),





                  Visibility(
                    visible: _contentVisiblity,
                    child: FutureBuilder(
                        initialData: const [],
                        future: _dbHelper.getTodo(_taskID),
                        builder: (BuildContext context, AsyncSnapshot snapshot)
                        {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context,index)
                                {
                                  return GestureDetector(
                                    onTap: () async
                                    {
                                      if(snapshot.data[index].isDone == 0)
                                      {
                                       await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                      }else
                                      {
                                      await  _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                      }
                                      setState(() {});
                                    },
                                    child: TodoWidget(
                                        text: snapshot.data[index].title,
                                        isDone: snapshot.data[index].isDone == 0 ? false:true,
                                    ),
                                  );
                                }
                            ),
                          );
                        }),
                  ),






                ],


              ),

              Visibility(
                visible: _contentVisiblity,
                child: Positioned(
                  bottom: 24, right: 24,
                  child: Container(
                    width: 60,height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () async
                      {
                        if(_taskID !=0)
                        {
                         await _dbHelper.deleteTodo(_taskID);
                         Navigator.pop(context);
                        }
                      },
                      icon:const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.white,
                      ),

                    ),
                  ),

                ),
              ),

            ],
          ),


        ),

      ),

    );
  }

  Future<void> insertData(String value) async {
       if(value.isNotEmpty)
    {
      if(widget.task == null)
      {
        DatabaseHelper _dbHelper = DatabaseHelper();
        TaskModel _newTask = TaskModel(
          // id: int.parse(value),
          title: value,
          description: value,
        );
         _taskID =  await _dbHelper.insertTasks(_newTask);
         setState(()
         {
           _contentVisiblity = true;
           _taskTitle = value;
         });
        print('new task id ==>> $_taskID');
      }else{
        await _dbHelper.updateTaskTitle(_taskID, _taskTitle);
        print('task updated');
      }

    }
  }
}
