import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference stepsReference =
    FirebaseFirestore.instance.collection('steps');

getStepsReference(){
  return stepsReference;
}

Future<QuerySnapshot<Object?>> getAllSteps() async {
  final QuerySnapshot stepsSnapshot = await stepsReference.get();
  return stepsSnapshot;
}
