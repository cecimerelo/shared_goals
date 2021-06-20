import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/data_access/goals_data_access.dart';
import 'package:fluttershare/data_access/users_data_access.dart';
import 'package:fluttershare/models/task.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/visualize_task.dart';

class GenericStepWidget extends StatefulWidget {
  final TaskEntity task;

  GenericStepWidget({required this.task});

  factory GenericStepWidget.fromDocument(DocumentSnapshot doc) {
    TaskEntity taskEntity = TaskEntity.fromDocument(doc);
    return GenericStepWidget(task: taskEntity);
  }

  @override
  _GenericStepWidgetState createState() =>
      _GenericStepWidgetState(task: this.task);
}

class _GenericStepWidgetState extends State<GenericStepWidget> {
  final TaskEntity task;
  String parentName = '';
  String photoUrl = 'https://www.baineswilson.co.uk/wp-content/uploads/2019/04/empty_user-e28be29d09f6ea715f3916ebebb525103ea068eea8842da42b414206c2523d01.png';
  String profileId = '';

  _GenericStepWidgetState({
    required this.task,
  });

  @override
  void initState() {
    super.initState();
    getPhotoURL();
    getGoalName();
  }

  getGoalName() async {
    String goalName = await getGoalNameById(widget.task.parentId);

    setState(() {
      parentName = goalName;
    });
  }

  getPhotoURL() async {
    DocumentSnapshot doc = await getCurrentUser(task.ownerId);
    User user = User.fromDocument(doc);

    setState(() {
      photoUrl = user.photoUrl;
      profileId = user.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    final int daysUntil = -today.difference(widget.task.deadline).inDays;

    return Card(
      child: Row(
        children: [
          GestureDetector(
            onTap: () => goToUserProfileTapped(context, profileId: profileId),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: CachedNetworkImageProvider(photoUrl),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => goToTaskVisualizePage(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text('${task.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                new Text('Goal : $parentName', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  goToUserProfileTapped(BuildContext context, {required String profileId}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Profile(profileId: profileId)));
  }

  goToTaskVisualizePage() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => VisualizeTask(task: task)));

}
