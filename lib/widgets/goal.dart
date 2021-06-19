import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/goal.dart';

class GoalWidget extends StatefulWidget {
  final GoalEntity goal;

  GoalWidget({required this.goal});

  factory GoalWidget.fromDocument(DocumentSnapshot doc) {
    GoalEntity goalEntity =  GoalEntity.fromDocument(doc);
    return GoalWidget(goal: goalEntity);
  }

  @override
  _GoalWidgetState createState() => _GoalWidgetState(
    goal: this.goal
  );
}

class _GoalWidgetState extends State<GoalWidget> {
  final GoalEntity goal;

  _GoalWidgetState({
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Post");
  }
}
