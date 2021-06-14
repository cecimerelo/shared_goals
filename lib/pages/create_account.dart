import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController usernameController = new TextEditingController();
  late String username;

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        appBar: header(context, titleText: 'Set up your profile'),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text('Create a username',
                        style: TextStyle(fontSize: 25.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: CupertinoTextFormFieldRow(
                      placeholder: 'Username',
                      controller: usernameController,
                    )
                  ),
                ),
                CupertinoButton(
                    child: Text('Submit'),
                    onPressed: submit,
                    color: Theme.of(context).primaryColor
                )
              ],),
            )
          ],
        )
    );
  }

  submit() {
    String username = usernameController.text;
    Navigator.pop(context, username);
  }
}
