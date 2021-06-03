import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersReference =
    FirebaseFirestore.instance.collection('users');

Future<QuerySnapshot<Object?>> getAllUsers() async {
  final QuerySnapshot usersSnapshot = await usersReference.get();
  return usersSnapshot;
}

void getUsersWhereFieldIsEqualToValue(fieldName, value) async {
  final QuerySnapshot usersSnapshot =
      await usersReference.where(fieldName, isEqualTo: value).get();
  usersSnapshot.docs.forEach((DocumentSnapshot doc) {
    print(doc.data());
  });
}
