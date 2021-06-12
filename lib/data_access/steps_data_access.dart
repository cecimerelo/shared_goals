import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/entities/task_entity.dart';

final CollectionReference steps =
    FirebaseFirestore.instance.collection('steps');

getStepsReference() {
  return steps;
}

Future<QuerySnapshot<Object?>> getAllSteps() async {
  final QuerySnapshot stepsSnapshot = await steps.get();
  return stepsSnapshot;
}

Future<void> addStep(Task step) {
  return steps.add({
    'deadline': step.deadline,
    'done': step.done,
    'isRoot': step.isRoot,
    'measuredIn' : step.measuredIn,
    'name': step.name,
    'parentId': step.parentId
  })
      .then((value) => print("Step Added"))
      .catchError((error) => print("Failed to add step: $error"));
}
