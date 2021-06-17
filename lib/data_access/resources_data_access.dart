import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/entities/resource.dart';

final CollectionReference resourcesReference =
FirebaseFirestore.instance.collection('resources');

Future<DocumentReference<Object?>> addResource(Resource resource) {
  return resourcesReference.add({
    'measuringUnitName': resource.measuringUnitName,
    'resource': resource.resource
  });
}