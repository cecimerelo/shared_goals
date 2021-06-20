import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/models/goal.dart';

final CollectionReference goalsReference =
    FirebaseFirestore.instance.collection('goals');

Future<QuerySnapshot<Object?>> getGoalsOrderedByCreationDate(
    String profileId) async {
  return goalsReference
      .where('ownerId', isEqualTo: profileId)
      .orderBy('createdOn', descending: true)
      .get();
}

Future<String> getGoalNameById(String goalId) async {
  DocumentSnapshot goal = await goalsReference.doc(goalId).get();
  Map? data = goal.data() as Map;
  return data['name'];
}

createGoal(GoalEntity goal) {
  goalsReference.doc(goal.id).set({
    'id': goal.id,
    'name': goal.name,
    'deadline': Timestamp.fromDate(goal.deadline),
    'createdOn': goal.createdOn,
    'tasksReference': goal.tasksReference,
    'ownerId': goal.ownerID,
    'username': goal.username
  });
}
