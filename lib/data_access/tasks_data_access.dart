import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/entities/task_entity.dart';

final CollectionReference tasks =
    FirebaseFirestore.instance.collection('tasks');

getTasksReference() {
  return tasks;
}

Future<QuerySnapshot<Object?>> getAllSteps() async {
  final QuerySnapshot stepsSnapshot = await tasks.get();
  return stepsSnapshot;
}

Future<DocumentReference<Object?>> addStep(Task task) {
  return tasks.add({
    'deadline': task.deadline,
    'done': task.done,
    'measuredIn': task.measuredIn,
    'name': task.name,
    'totalEffort': task.totalEffort,
    'parentID': task.parentID,
    'resourcesReference': task.resourcesReference
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
