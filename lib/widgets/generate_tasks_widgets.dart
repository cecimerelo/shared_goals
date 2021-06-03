import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/add_task_form.dart';

class GenerateTasksWidgets extends StatefulWidget {
  GenerateTasksWidgets({Key? key}) : super(key: key);

  @override
  _GenerateTasksWidgetsState createState() => _GenerateTasksWidgetsState();
}

class _GenerateTasksWidgetsState extends State<GenerateTasksWidgets> {
  List<String> dynamicListOfTasks = [];
  Icon floatingIcon = new Icon(Icons.add);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          CupertinoButton(
              onPressed: () =>
                  {Navigator.of(context).push(_addTaskForm())},
              child: new Icon(Icons.add))
        ],
      ),
    );
  }

  Route<Object?> _addTaskForm() {
    return CupertinoPageRoute(
        builder: (_) => AddTaskForm());
  }
}
