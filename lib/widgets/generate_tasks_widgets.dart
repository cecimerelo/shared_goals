import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/entities/task_entity.dart';
import 'package:fluttershare/pages/add_task_form.dart';
import 'package:fluttershare/pages/edit_task_form.dart';

class GenerateTasksWidgets extends StatefulWidget {
  GenerateTasksWidgets({Key? key}) : super(key: key);

  late List<Task> dynamicListOfTasks = [];

  @override
  _GenerateTasksWidgetsState createState() => _GenerateTasksWidgetsState();
}

class _GenerateTasksWidgetsState extends State<GenerateTasksWidgets> {
  Icon floatingIcon = new Icon(Icons.add);

  @override
  Widget build(BuildContext context) {
    Widget result = new Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: new Card(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.dynamicListOfTasks.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(5.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                      secondary: InkWell(
                          child: new Icon(Icons.edit),
                          onTap: () =>
                              {Navigator.of(context).push(_editTaskForm())}),
                      onChanged: (bool? value) {},
                      title: new Text("${widget.dynamicListOfTasks[index].name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19)),
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
            onTaskAdded: (Task newTask) =>
                setState(() => widget.dynamicListOfTasks.add(newTask))));
  }

  Route<Object?> _editTaskForm() {
    return CupertinoPageRoute(builder: (_) => EditTaskForm());
  }
}
