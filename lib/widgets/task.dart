import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/task.dart';

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
    return Container(child: Text('ceci'),);
  }
}