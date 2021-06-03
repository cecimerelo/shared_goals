import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/generate_tasks_widgets.dart';
import 'package:fluttershare/widgets/header.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController goalTitle = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime goalDeadline;

    return Scaffold(
        appBar: header(context, titleText: "Upload Goal"),
        body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  CupertinoFormSection(
                    children: <Widget>[
                      CupertinoTextFormFieldRow(
                        placeholder: 'What do you want to achieve ? ',
                        controller: goalTitle,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Goal Name';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  'Deadline',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.3),
                                ),
                                Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                      minimumYear: 2020,
                                      maximumYear: 2050,
                                      onDateTimeChanged: (DateTime value) {
                                        goalDeadline = value;
                                      },
                                      initialDateTime: DateTime.now(),
                                      use24hFormat: true,
                                      mode: CupertinoDatePickerMode.date),
                                ),
                              ],
                        )),
                      )
                    ],
                  ),
                  CupertinoFormSection(
                    header: Text('Tasks'),
                    children: [
                      GenerateTasksWidgets()
                    ],
                  )
                ],
              ),
            )));
  }
}
