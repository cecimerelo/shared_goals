import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceEntity {
  String measuringUnitName;
  String resource;
  String taskName;

  ResourceEntity(this.measuringUnitName, this.resource, this.taskName);

  factory ResourceEntity.fromDocument(DocumentSnapshot doc) {
    return ResourceEntity(doc['measuringUnitName'], doc['resource'], doc['taskName']);
  }
}
