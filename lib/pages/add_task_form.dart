import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/data_access/resources_data_access.dart';
import 'package:fluttershare/entities/measuring_unit_entity.dart';
import 'package:fluttershare/entities/resource.dart';
import 'package:fluttershare/entities/task_entity.dart';

class AddTaskForm extends StatefulWidget {
  AddTaskForm({Key? key, required this.onTaskAdded}) : super(key: key);

  final Function(Task) onTaskAdded;

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
  late TextEditingController _totalEffort = new TextEditingController(text: '0');

  IconData resourceIcon = Icons.auto_stories;
  DateTime deadline = DateTime.now();
  final List<TextEditingController> _resource = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("New Task"),
        ),
        body: Column(
          children: [
          Form(
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
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, top: 15.0, right: 0.0, bottom: 15.0),
                    child: CupertinoFormSection(
                        children: [measuredInRow(), totalEffortRow()]),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: Column(
                          children: [
                            Text(
                              'Deadline',
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 100,
                              child: CupertinoDatePicker(
                                  minimumYear: 2020,
                                  maximumYear: 2050,
                                  onDateTimeChanged: (DateTime value) {
                                    deadline = value;
                                  },
                                  initialDateTime: DateTime.now(),
                                  use24hFormat: true,
                                  mode: CupertinoDatePickerMode.date),
                            ),
                          ],
                        )
                    ),
                  ),
                  CupertinoFormSection(header: Text('Resources'), children: [
                    Center(
                      child: int.parse(_totalEffort.text) == 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No effort added yet...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : _resourceFormRow(int.parse(_totalEffort.text)),
                    )
                  ]),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoButton.filled(
                onPressed: () => saveTask(context),
                child: const Text('Save'),
              ),
            )
          ],
        ),
    );
  }

  ListView _resourceFormRow(int itemCount) => ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        TextEditingController resourceController = TextEditingController();
        _resource.add(resourceController);

        return new CupertinoTextFormFieldRow(
            autocorrect: true,
            prefix: Icon(resourceIcon),
            controller: resourceController);
      });

  Row measuredInRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                  child: Text('Measured in',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17)),
              )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildMeasuringUnitsDropdownButtonFormField(),
            ),
          ),
        ],
      );

  Row totalEffortRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text('Total effort',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17)),
          )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new CupertinoTextFormFieldRow(
                    placeholder: 'Quantity',
                    controller: _totalEffort,
                    onChanged: (String effort) {
                      if (effort != '') {
                        int intEffort = int.parse(effort);
                        int editedEffort = intEffort > 0 ? intEffort : 0;
                        setState(() {
                          _totalEffort =
                              TextEditingController(text: "$editedEffort");
                        });
                      }

                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ]),
              )),
          Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text('${selectedUnit.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey)),
          ))
        ],
      );

  DropdownButtonFormField<MeasuringUnit>
      buildMeasuringUnitsDropdownButtonFormField() =>
          DropdownButtonFormField<MeasuringUnit>(
              value: selectedUnit,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 20,
              elevation: 16,
              onChanged: (MeasuringUnit? newValue) {
                setState(() {
                  resourceIcon = _getIcon(newValue!);
                  selectedUnit = newValue;
                });
              },
              items: _dropdownMeasuringUnitsItems);

  saveTask(BuildContext context) async {
    List<DocumentReference> resourcesReference = [];

    for (TextEditingController controller in _resource) {
      Resource resource = Resource(selectedUnit.id, controller.text);
      await addResource(resource)
          .then((value) => resourcesReference.add(value));
    }

    Task newTask = Task(deadline, false, selectedUnit.id, _taskTitle.text,
        _totalEffort.text, '', resourcesReference);
    widget.onTaskAdded(newTask);
    Navigator.of(context).pop();
  }

  IconData _getIcon(MeasuringUnit measuringUnit ) {
    if (selectedUnit.id == 'books') {
      return Icons.auto_stories;
    } else if (measuringUnit.id == 'courses') {
      return Icons.school;
    }
    return Icons.access_time;
  }

}
