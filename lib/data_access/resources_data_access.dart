import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/entities/resource.dart';

final CollectionReference resourcesReference =
FirebaseFirestore.instance.collection('resources');

Future<DocumentReference<Object?>> addResource(ResourceEntity resource) {
  return resourcesReference.add({
    'measuringUnitName': resource.measuringUnitName,
    'resource': resource.resource
  });
}

Future<QuerySnapshot<Object?>> getTaskResources(String taskName) async {
  return resourcesReference.where('taskName', isEqualTo: taskName).get();
}
