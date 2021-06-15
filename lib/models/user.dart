import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // we will specify the values that we will have for each user
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayName;
  final String bio;
  final String timestamp;

  User(this.id, this.username, this.photoUrl, this.email, this.displayName,
      this.bio, this.timestamp);

  factory User.fromDocument(DocumentSnapshot doc) {
    String auxTime = doc['timestamp'].toString();

    return User(doc['id'], doc['username'], doc['photoUrl'], doc['email'],
        doc['displayName'], doc['bio'], auxTime);
  }
}
