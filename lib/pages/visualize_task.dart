import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/resources_data_access.dart';
import 'package:fluttershare/models/task.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/resource.dart';
import 'package:intl/intl.dart';

class VisualizeTask extends StatefulWidget {
  final TaskEntity task;
  VisualizeTask({Key? key, required this.task}) : super(key: key);

  @override
  _VisualizeTaskState createState() => _VisualizeTaskState();
}

class _VisualizeTaskState extends State<VisualizeTask> {
  List<ResourceWidget> resources = [];

  @override
  void initState() {
    super.initState();
    getResourceTasks();
  }

  getResourceTasks() async {
    QuerySnapshot resourceSnapshots = await getTaskResources(widget.task.name);

    setState(() {
      resources = resourceSnapshots.docs
          .map((goal) => ResourceWidget.fromDocument(goal))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateFormatted =
    DateFormat('yyyy-MM-dd – kk:mm').format(widget.task.deadline);
    DateTime today = DateTime.now();

    final int daysUntil = today.difference(widget.task.deadline).inDays;

    return Scaffold(
      appBar: header(context, titleText: 'Task: ${widget.task.name}'),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Deadline:',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(dateFormatted, style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        Text(
                          'Days left: ',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        Text('$daysUntil',
                            style: TextStyle(fontSize: 15, color: Colors.red)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Text(
              'Resources',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(children: resources)
          ],
        ),
      ),
    );
  }
}