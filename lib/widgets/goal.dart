import 'dart:ui';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/tasks_data_access.dart';
import 'package:fluttershare/models/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalWidget extends StatefulWidget {
  final GoalEntity goal;

  GoalWidget({required this.goal});

  factory GoalWidget.fromDocument(DocumentSnapshot doc) {
    GoalEntity goalEntity = GoalEntity.fromDocument(doc);
    return GoalWidget(goal: goalEntity);
  }

  @override
  _GoalWidgetState createState() => _GoalWidgetState(goal: this.goal);
}

class _GoalWidgetState extends State<GoalWidget> {
  final GoalEntity goal;
  double completedTasksPercentage = 0.0;

  _GoalWidgetState({
    required this.goal,
  });

  @override
  void initState() {
    super.initState();
    getPercentageOfTasksDone();
  }

  getPercentageOfTasksDone() async {
    int numberOfTasksDone = await getNumberOfTasksDone(goal.tasksReference);
    completedTasksPercentage = (numberOfTasksDone / goal.tasksReference.length);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => print('tapped'),
        child: new LinearPercentIndicator(
          center: Text('${goal.name}',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
          width: MediaQuery.of(context).size.width - 50,
          lineHeight: 120.0,
          percent: completedTasksPercentage,
          alignment: MainAxisAlignment.spaceEvenly,
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
          progressColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(0.8),
        ),
      ),
    );
  }
}
