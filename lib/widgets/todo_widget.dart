import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  const TodoWidget({Key? key,@required this.text,required this.isDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              onPressed: ()
              {

              },
               icon:isDone ? const Icon(
                 Icons.check_box,
                  color:Colors.deepPurple,
              ): const Icon(
                 Icons.check_box,
                 color:Colors.grey,
               ),

            ),
          ),
          Flexible(
            child: Text(
             text?? '(UnNamed Todo)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
        ],
      ),
    );
  }
}
