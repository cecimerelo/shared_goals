import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  DateTime deadline;
  bool done;
  String measuredIn;
  String name;
  String totalEffort;
  String parentID;
  List<DocumentReference> resourcesReference;

  Task(this.deadline, this.done, this.measuredIn, this.name, this.totalEffort,
      this.parentID, this.resourcesReference);

  factory Task.fromDocument(DocumentSnapshot doc) {
    DateTime auxDeadline = DateTime.parse(doc['deadline'].toDate().toString());

    return Task(auxDeadline, doc['done'], doc['measuredIn'], doc['name'],
        doc['totalEffort'], doc['parentID'], doc['resourcesReference']);
  }
}
