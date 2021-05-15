import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/dataAccess/steps_data_access.dart';
import 'package:fluttershare/widgets/header.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> steps = [];

  @override
  void initState() {
    setStep();
    super.initState();
  }

  Future setStep() async {
    final QuerySnapshot stepsSnapshot = await getAllSteps();

    setState(() {
      steps = stepsSnapshot.docs;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: Container(
            // TODO: build steps widget
            child: ListView(
                children: steps.map((step) => Text(step['name'])).toList()
            )
        )
    );
  }
}
