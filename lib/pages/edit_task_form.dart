import 'package:flutter/material.dart';
import 'package:fluttershare/entities/task_entity.dart';

class EditTaskForm extends StatefulWidget {
  EditTaskForm(Task taskToEdit, {Key? key}) : super(key: key);

  @override
  _EditTaskFormState createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
      )
    );
  }
}