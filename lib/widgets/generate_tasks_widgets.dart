import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/add_task_form.dart';

class GenerateTasksWidgets extends StatefulWidget {
  GenerateTasksWidgets({Key? key}) : super(key: key);

  late List<String> dynamicListOfTasks = [];

  @override
  _GenerateTasksWidgetsState createState() => _GenerateTasksWidgetsState();
}

class _GenerateTasksWidgetsState extends State<GenerateTasksWidgets> {
  Icon floatingIcon = new Icon(Icons.add);

  @override
  Widget build(BuildContext context) {
    Widget result = new Flexible(
        flex: 2,
        fit: FlexFit.loose,
        child: new Card(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.dynamicListOfTasks.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 10.0),
                      child: new Text(
                          "${index + 1}. ${widget.dynamicListOfTasks[index]}"),
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    return new Center(
      child: new Column(
        children: <Widget>[
          Column(mainAxisSize: MainAxisSize.min, children: [
            widget.dynamicListOfTasks.length == 0 ? Container() : result
          ]),
          CupertinoButton(
              onPressed: () => {Navigator.of(context).push(_addTaskForm())},
              child: new Icon(Icons.add))
        ],
      ),
    );
  }

  Route<Object?> _addTaskForm() {
    return CupertinoPageRoute(
        builder: (_) => AddTaskForm(
            onTaskAdded: (String newTaskTitle) =>
                setState(() => widget.dynamicListOfTasks.add(newTaskTitle))));
  }
}
