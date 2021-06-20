import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/tasks_data_access.dart';
import 'package:fluttershare/models/task.dart';
import 'package:fluttershare/widgets/generic_step_widget.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<GenericStepWidget> steps = [];

  @override
  void initState() {
    setStep();
    super.initState();
  }

  setStep() async {
    final QuerySnapshot stepsSnapshot = await getAllUndoneSteps();

    setState(() {
      steps = stepsSnapshot.docs
          .map((goal) => GenericStepWidget.fromDocument(goal))
          .toList();
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: Column(children: steps)
    );
  }
}
