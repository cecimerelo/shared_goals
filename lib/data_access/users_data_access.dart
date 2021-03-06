import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersReference =
    FirebaseFirestore.instance.collection('users');

CollectionReference getUsersReference() {
  return usersReference;
}

Future<QuerySnapshot<Object?>> getAllUsers() async {
  final QuerySnapshot usersSnapshot = await usersReference.get();
  return usersSnapshot;
}

Future<QuerySnapshot<Object?>> getUsersWhereFieldIsEqualTo(
    fieldName, query) {
  return usersReference.orderBy(fieldName).startAt([query]).endAt([query + '\uf8ff']).get();
}

Future<DocumentSnapshot<Object?>> getCurrentUser(String profileId) {
  return usersReference.doc(profileId).get();
}

void getUsersWhereFieldIsEqualToValue(fieldName, value) async {
  final QuerySnapshot usersSnapshot =
      await usersReference.where(fieldName, isEqualTo: value).get();
  usersSnapshot.docs.forEach((DocumentSnapshot doc) {
    print(doc.data());
  });
}
