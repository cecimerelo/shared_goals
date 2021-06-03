import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeasuringUnit {
  String id;
  String name;

  MeasuringUnit(this.id, this.name);

  static List<MeasuringUnit> getItems() {
    return <MeasuringUnit>[
      MeasuringUnit("books", "book(s)"),
      MeasuringUnit("courses", "course(s)"),
      MeasuringUnit("hours", "hour(s)"),
    ];
  }

  static List<DropdownMenuItem<MeasuringUnit>>? buildDropdownMenuItems(
      List<MeasuringUnit> measuringUnits) {
    List<DropdownMenuItem<MeasuringUnit>> items = [];
    for (MeasuringUnit unit in measuringUnits) {
      items.add(
        DropdownMenuItem(
          value: unit,
          child: Text(unit.name),
        ),
      );
    }
    return items;
  }
}

class AddTaskForm extends StatefulWidget {
  AddTaskForm({Key? key}) : super(key: key);

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  List<MeasuringUnit> _ingredientMeasuringUnits = MeasuringUnit.getItems();

  late List<DropdownMenuItem<MeasuringUnit>> _dropdownMeasuringUnitsItems =
      MeasuringUnit.buildDropdownMenuItems(_ingredientMeasuringUnits)!;
  late MeasuringUnit selectedUnit = _dropdownMeasuringUnitsItems[0].value!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitle = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Task"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                CupertinoFormSection(children: [
                  CupertinoTextFormFieldRow(
                    placeholder: 'Task title ',
                    controller: _taskTitle,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    maxLines: 4,
                    placeholder: 'Enter a description here',
                    controller: _description,
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, top: 15.0, right: 0.0, bottom: 15.0),
                  child: CupertinoFormSection(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                                  child: Text('Measured in',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 17
                                      )
                                  ),
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildMeasuringUnitsDropdownButtonFormField(),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  DropdownButtonFormField<MeasuringUnit>
      buildMeasuringUnitsDropdownButtonFormField() =>
          DropdownButtonFormField<MeasuringUnit>(
              value: selectedUnit,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 20,
              elevation: 16,
              onChanged: (MeasuringUnit? newValue) {
                setState(() {
                  selectedUnit = newValue!;
                });
              },
              items: _dropdownMeasuringUnitsItems);
}
