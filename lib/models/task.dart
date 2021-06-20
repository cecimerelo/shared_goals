import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  DateTime deadline;
  bool done;
  String measuredIn;
  String name;
  String totalEffort;
  String parentId;
  List<dynamic> resourcesReference;
  String ownerId;

  TaskEntity(this.deadline, this.done, this.measuredIn, this.name,
      this.totalEffort, this.parentId, this.resourcesReference, this.ownerId);

  factory TaskEntity.fromDocument(DocumentSnapshot doc) {
    DateTime auxDeadline = DateTime.parse(doc['deadline'].toDate().toString());

    return TaskEntity(
        auxDeadline,
        doc['done'],
        doc['measuredIn'],
        doc['name'],
        doc['totalEffort'],
        doc['parentId'],
        doc['resourcesReference'],
        doc['ownerId']);
  }
}
