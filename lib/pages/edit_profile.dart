import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttershare/data_access/users_data_access.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'home.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({required this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  User user = User(
      'id', 'username', 'photoUrl', 'email', 'displayName', 'bio', 'timestamp');
  String displayName = '';
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot doc = await getCurrentUser(widget.currentUserId);
    user = User.fromDocument(doc);

    displayName = user.displayName;
    bioController.text = user.bio;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: isLoading
          ? circularProgress(context)
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                CachedNetworkImageProvider(user.photoUrl),
                          )),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[Text(displayName)],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CupertinoButton(
                            color: Colors.red,
                            child: Text('logout'),
                            onPressed: logout),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}
