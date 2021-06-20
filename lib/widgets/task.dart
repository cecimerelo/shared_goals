import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/goals_data_access.dart';
import 'package:fluttershare/models/task.dart';
import 'package:fluttershare/pages/visualize_task.dart';

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
  String parentName = '';

  @override
  void initState() {
    super.initState();
    getGoalName();
  }

  getGoalName() async {
    String goalName = await getGoalNameById(task.parentId);

    setState(() {
      parentName = goalName;
    });
  }

  _TaskWidgetState({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    final int daysUntil = - today.difference(task.deadline).inDays;

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
                  onTap: () => goToTaskVisualizePage(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: new Text('${task.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                      new Text('Goal : $parentName',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                subtitle: Text('Days left: $daysUntil',
                    style: TextStyle(fontSize: 15, color: Colors.red)),
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

  goToTaskVisualizePage() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => VisualizeTask(task: task)));
}
