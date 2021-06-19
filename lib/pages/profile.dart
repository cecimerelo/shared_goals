import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttershare/data_access/goals_data_access.dart';
import 'package:fluttershare/data_access/users_data_access.dart';
import 'package:fluttershare/globals.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/edit_profile.dart';
import 'package:fluttershare/widgets/goal.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({required this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser.id;
  bool isLoading = false;
  int goalCount = 0;
  List<GoalWidget> goals = [];

  @override
  void initState() {
    super.initState();
    getProfileGoals();
  }

  getProfileGoals() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot =
        await getGoalsOrderedByCreationDate(widget.profileId);

    setState(() {
      isLoading = false;
      goalCount = snapshot.docs.length;
      goals =
          snapshot.docs.map((goal) => GoalWidget.fromDocument(goal)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: "Profile"),
        body: ListView(
          children: <Widget>[
            buildProfileHeader(),
            Divider(height: 0.0),
            buildProfileGoals()
          ],
        ));
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: getCurrentUser(widget.profileId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(context);
          }
          User user = User.fromDocument(snapshot.data!);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl)),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            buildProfileValuesRow(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [buildEditProfileButton()])
                          ],
                        ))
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    user.username,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(user.bio),
                )
              ],
            ),
          );
        });
  }

  Row buildProfileValuesRow() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildProfileValuesColumn('goals', 0),
            buildProfileValuesColumn('tasks', 0),
            buildProfileValuesColumn('followers', 0)
          ]);

  Column buildProfileValuesColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(count.toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  buildEditProfileButton() {
    // if we are seeing our own profile
    bool isProfileOwner = currentUserId == widget.profileId ? true : false;
    if (isProfileOwner) {
      return buildButton(text: 'Edit Profile', function: editProfile);
    }
  }

  Container buildButton({required String text, required VoidCallback function}) {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: TextButton(
          onPressed: function,
          child: Container(
            width: 250.0,
            height: 27.0,
            child: Text(text,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ));
  }

  void editProfile() => SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EditProfile(currentUserId: currentUserId)));
    });

  buildProfileGoals() {
    if(isLoading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: circularProgress(context),
      );
    }
    return Column(children: goals);
  }
}
