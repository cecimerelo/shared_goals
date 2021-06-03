import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference goalsReference =
    FirebaseFirestore.instance.collection('goals');

createGoal(name, dateTime, steps) {
  goalsReference.add({
    'name': name,
    'deadline': Timestamp.fromDate(new DateTime(dateTime)),
    'createdOn': Timestamp.now(),
    'steps': steps
  });
}