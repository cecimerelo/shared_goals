import 'package:cloud_firestore/cloud_firestore.dart';

class GoalEntity {
  String id;
  DateTime deadline;
  String name;
  List<dynamic> tasksReference;
  String ownerID;
  String username;
  Timestamp createdOn;

  GoalEntity(this.id, this.deadline, this.name, this.tasksReference,
      this.ownerID, this.username, this.createdOn);

  factory GoalEntity.fromDocument(DocumentSnapshot doc) {
    DateTime auxDeadline = DateTime.parse(doc['deadline'].toDate().toString());

    return GoalEntity(
        '',
        auxDeadline,
        doc['name'],
        doc['tasksReference'],
        doc['ownerId'],
        doc['username'],
        doc['createdOn']);
  }
}
