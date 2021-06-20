import 'package:flutter/material.dart';
import 'package:fluttershare/models/task.dart';

class EditTaskForm extends StatefulWidget {
  EditTaskForm(TaskEntity taskToEdit, {Key? key}) : super(key: key);

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