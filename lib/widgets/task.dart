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
  late bool _isChecked = false;

  _TaskWidgetState({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    String dateFormatted =
        DateFormat('yyyy-MM-dd – kk:mm').format(task.deadline);

    return Row(children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: new CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _isChecked,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
                title: new Text("${task.name}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                subtitle: Text('$dateFormatted'),
                secondary: InkWell(
                    child: new Icon(Icons.edit),
                    onTap: () => {print('tapped')}),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
