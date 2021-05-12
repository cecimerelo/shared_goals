import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/pages/timeline.dart';
import 'package:fluttershare/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print("Error signing in: $err");
    });

    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => handleSignIn(account))
        .catchError((err) {
      print("Error signing in: $err");
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      print("User signed in!: $account");
      setState(() {
        isAuth = true;
      });
    } else {
      isAuth = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen(context) : buildUnAuthScreen();
  }

  Scaffold buildAuthScreen(context) {
    // return CupertinoButton(
    //   child: Text("Log Out"),
    //   onPressed: logout
    // );

    return Scaffold(
      body: PageView(
        // contains all the pages that we want
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile()
        ],
        // enable us to switch between the pages
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTapTabBar,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.edit, size: 35.0)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle))
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ])),
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Shared Goals",
                style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 90.0,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: login,
                child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/google_signin_button.png'),
                          fit: BoxFit.cover),
                    )),
              ),
            ]),
      ),
    );
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
    setState(() {});
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTapTabBar(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
