import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String? title;
  final String? desc;

  const TaskCard({Key? key , required this.title , @required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,

      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             title?? 'UnNamed Task!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
                desc ?? 'No Description Added',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5
              ) ,
            ),
          ),
        ],
      ),
    );
  }
}
