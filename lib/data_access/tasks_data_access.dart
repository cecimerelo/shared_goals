import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/models/task.dart';

final CollectionReference tasks =
    FirebaseFirestore.instance.collection('tasks');

getTasksReference() {
  return tasks;
}

Future<QuerySnapshot<Object?>> getAllUndoneSteps() async {
  final QuerySnapshot stepsSnapshot =
      await tasks.where('done', isEqualTo: false).get();
  return stepsSnapshot;
}

Future<QuerySnapshot<Object?>> getUndoneStepsOrderedByDeadline(
    String profileId) async {
  return tasks
      .where('ownerId', isEqualTo: profileId)
      .where('done', isEqualTo: false)
      .orderBy('deadline', descending: true)
      .get();
}

Future<QuerySnapshot<Object?>> getGoalStepsOrderedByDeadline(
    String profileId, goalId) async {
  return tasks
      .where('parentId', isEqualTo: goalId)
      .where('ownerId', isEqualTo: profileId)
      .orderBy('deadline', descending: true)
      .get();
}

Future<DocumentReference<Object?>> addStep(TaskEntity task) {
  return tasks.add({
    'deadline': task.deadline,
    'done': task.done,
    'measuredIn': task.measuredIn,
    'name': task.name,
    'totalEffort': task.totalEffort,
    'parentId': task.parentId,
    'resourcesReference': task.resourcesReference,
    'ownerId': task.ownerId
  });
}

Future<int> getNumberOfTasksDone(List<dynamic> tasksReferences) async {
  int counter = 0;
  for (DocumentReference taskReference in tasksReferences) {
    final DocumentSnapshot stream = await taskReference.get();
    Map? data = stream.data() as Map;
    counter = data['done'] ? counter + 1 : counter + 0;
  }
  return counter;
}
