import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/tasks_data_access.dart';
import 'package:fluttershare/globals.dart';
import 'package:fluttershare/models/goal.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/task.dart';
import 'package:intl/intl.dart';

class VisualizeGoal extends StatefulWidget {
  final GoalEntity goal;

  VisualizeGoal({Key? key, required this.goal}) : super(key: key);

  @override
  _VisualizeGoalState createState() => _VisualizeGoalState();
}

class _VisualizeGoalState extends State<VisualizeGoal> {
  List<TaskWidget> tasks = [];

  @override
  void initState() {
    super.initState();
    getGoalTasks();
  }

  getGoalTasks() async {
    QuerySnapshot taskSnapshots =
        await getGoalStepsOrderedByDeadline(currentUser.id, widget.goal.id);

    setState(() {
      tasks = taskSnapshots.docs
          .map((goal) => TaskWidget.fromDocument(goal))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateFormatted =
        DateFormat('yyyy-MM-dd – kk:mm').format(widget.goal.deadline);
    DateTime today = DateTime.now();

    final int daysUntil = today.difference(widget.goal.deadline).inDays;

    return Scaffold(
      appBar: header(context, titleText: '${widget.goal.name}'),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Deadline:',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(dateFormatted, style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        Text(
                          'Days left: ',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        Text('$daysUntil',
                            style: TextStyle(fontSize: 15, color: Colors.red)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Text(
              'Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(children: tasks)
          ],
        ),
      ),
    );
  }
}
