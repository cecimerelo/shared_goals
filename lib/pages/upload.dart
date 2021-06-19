import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/goals_data_access.dart';
import 'package:fluttershare/data_access/tasks_data_access.dart';
import 'package:fluttershare/entities/task_entity.dart' as task_entity;
import 'package:fluttershare/models/goal.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/generate_tasks_widgets.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class Upload extends StatefulWidget {
  final User currentUser;

  Upload({required this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _goalTitle = new TextEditingController(text: '');
  bool isUploading = false;
  late DateTime goalDeadline = DateTime.now();
  List<firebase_storage.Task> tasksToSave = [];
  GenerateTasksWidgets generateTasksWidgets = new GenerateTasksWidgets();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: header(context, titleText: "Upload Goal"),
        body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  CupertinoFormSection(
                    children: <Widget>[
                      CupertinoTextFormFieldRow(
                        placeholder: 'What do you want to achieve ? ',
                        controller: _goalTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  'Deadline',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.3),
                                ),
                                Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                      minimumYear: 2020,
                                      maximumYear: 2050,
                                      onDateTimeChanged: (DateTime value) {
                                        goalDeadline = value;
                                      },
                                      initialDateTime: DateTime.now(),
                                      use24hFormat: true,
                                      mode: CupertinoDatePickerMode.date),
                                ),
                              ],
                        )),
                      )
                    ],
                  ),
                  CupertinoFormSection(
                    header: Text('Tasks'),
                    children: [
                      generateTasksWidgets
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton.filled(
                      onPressed: () => handleSubmit(),
                      child: const Text('Save'),
                    ),
                  )
                ],
              ),
            )));
  }

  handleSubmit() {
    if (!isUploading) {
      setState(() {
        isUploading = true;
      });
      createGoalInFirestore(
          deadline: goalDeadline,
          name: _goalTitle.text);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  createGoalInFirestore(
      {
      required DateTime deadline,
      required String name}) async {

    String parentId = Uuid().v4();

    List<String> tasksReference = await saveTasksInFireStore(parentId);
    GoalEntity goal = GoalEntity(parentId, deadline, name, tasksReference,
        widget.currentUser.id, widget.currentUser.username, Timestamp.now());
    createGoal(goal);
  }

  Future<List<String>> saveTasksInFireStore(String parentId) async {
    List<String> tasksReference= [];
    for(var i=0;i<generateTasksWidgets.dynamicListOfTasks.length;i++){
      task_entity.Task task = generateTasksWidgets.dynamicListOfTasks[i];
      task.parentID = parentId;
      await addStep(task).then((value) =>
          tasksReference.add(value.path));
    }
    return tasksReference;
    }

}
