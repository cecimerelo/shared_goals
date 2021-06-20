import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/task.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  final TaskEntity task;

  TaskWidget({required this.task});

  factory TaskWidget.fromDocument(DocumentSnapshot doc) {
    TaskEntity taskEntity = TaskEntity.fromDocument(doc);
    return TaskWidget(task: taskEntity);
  }

  @override
  _TaskWidgetState createState() => _TaskWidgetState(task: this.task);
}

class _TaskWidgetState extends State<TaskWidget> {
  final TaskEntity task;

  _TaskWidgetState({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    String dateFormatted =
        DateFormat('yyyy-MM-dd – kk:mm').format(task.deadline);
    DateTime today = DateTime.now();
    final int daysUntil = today.difference(task.deadline).inDays;

    return Row(children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: new CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: task.done,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool? value) {
                  // TODO: save state in firebase
                  setState(() {
                    task.done = value!;
                  });
                },
                title: GestureDetector(
                  onTap: () => {print('tapped')},
                  child: new Text("${task.name}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                subtitle: Text('Days left: $daysUntil',
                    style: TextStyle(fontSize: 15, color: Colors.red)),
                secondary: InkWell(
                    child: new Icon(Icons.edit),
                    // TODO: define functionality
                    onTap: () => {print('tapped')}),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
