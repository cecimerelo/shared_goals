import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/data_access/users_data_access.dart';
import 'package:fluttershare/models/user.dart';
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
    Future<QuerySnapshot> usersSearched =
        getUsersWhereFieldIsEqualTo('username', query);

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
          List<Text> searchResults = [];
          snapshot.data!.docs.forEach((doc) {
            User user = User.fromDocument(doc);
            searchResults.add(Text(user.username));
          });
          return ListView(
            children: searchResults,
          );
        });
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
