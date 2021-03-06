import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/data_access/users_data_access.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late var searchResultsFuture;

  @override
  void initState() {
    searchResultsFuture = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildSearchField(),
        body: searchResultsFuture == null
            ? buildNoContent()
            : buildSearchResults());
  }

  AppBar buildSearchField() {
    return AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          onSubmitted: (String query) {
            handleSearch(query);
          },
          placeholder: 'Search for a user ...',
        ));
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text('Find Users',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 60.0))
          ],
        ),
      ),
    );
  }

  handleSearch(String query) {
    Future<QuerySnapshot> usersSearched;
    if(query.length != 0) {
      usersSearched = getUsersWhereFieldIsEqualTo('username', query);
    } else{
      usersSearched = getUsersWhereFieldIsEqualTo('username', 'razzmatazz');
    }

    setState(() {
      searchResultsFuture = usersSearched;
    });
  }

  buildSearchResults() {
    return FutureBuilder(
        future: searchResultsFuture,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(context);
          }
          List<UserResult> searchResults = [];
          snapshot.data!.docs.forEach((doc) {
            User user = User.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });

          if (searchResults.isEmpty) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'No users found ...',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ));
          }
          return ListView(
            children: searchResults,
          );
        });
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        GestureDetector(
          onTap: () => goToUserProfileTapped(context, profileId: user.id),
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(user.displayName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.grey),
              )),
        ),
        Divider(
          height: 2.0,
          color: Colors.white54,
        )
      ]),
    );
  }

  goToUserProfileTapped(BuildContext context, {required String profileId}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Profile(profileId: profileId)));
  }
}
