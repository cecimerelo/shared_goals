import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/entities/goal_entity.dart';

final CollectionReference goalsReference =
    FirebaseFirestore.instance.collection('goals');

createGoal(Goal goal) {
  goalsReference.doc(goal.id).set({
    'name': goal.name,
    'deadline': Timestamp.fromDate(goal.deadline),
    'createdOn': Timestamp.now(),
    'tasksReference': goal.tasksReference
  });
}