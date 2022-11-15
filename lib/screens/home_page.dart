import 'package:flutter/material.dart';
import 'package:todo_app/database/database_helper.dart';
import 'package:todo_app/screens/task_screen.dart';
import 'package:todo_app/widgets/scroll_behaviour.dart';
import 'package:todo_app/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}


class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper =DatabaseHelper();
  @override
  void initState() {
_dbHelper.dataBase();
 super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          margin: const EdgeInsets.only(
            bottom: 20,
          ),
          child:Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 32,
                      bottom: 32
                    ),
                    child: const Image(
                      width: 200,
                      height: 140,
                      image: AssetImage(
                        'assets/images/logoo.png',

                      ),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: FutureBuilder(
                        initialData: const [],
                        future: _dbHelper.getTasks(),
                        builder: (BuildContext context, AsyncSnapshot snapshot)
                        {
                          if(snapshot.hasData)
                          {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context ,index)
                                {
                                  return GestureDetector(
                                    onTap: ()
                                    {
                                      Navigator.push(context,MaterialPageRoute(builder: (context){
                                        return TaskPage(
                                          task:snapshot.data[index] ,
                                        );
                                      }),)
                                      .then((value)
                                      {
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCard(
                                      title: snapshot.data[index].title,
                                      desc: snapshot.data[index].description,
                                    ),
                                  );

                                }
                            );
                          }else
                          {
                            return const Center(child: CircularProgressIndicator());
                          }

                        },
                      ),
                    ),
                  ),

                ],
              ),
              Positioned(
                bottom: 24, right: 0,
                child: Container(
                  width: 60,height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                            =>TaskPage(id: 0,),
                        ),
                      ).then((value)
                      {
                        setState(() {

                        });
                      });
                    },
                    icon:const Icon(
                      Icons.add,
                      color: Colors.white,
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
}
