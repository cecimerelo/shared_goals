import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/entities/measuring_unit_entity.dart';
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
  final TextEditingController _description = new TextEditingController();
  DateTime deadline = DateTime.now();

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
                      child: CupertinoFormSection(children: [
                        measuredInRow(),
                        totalEffortRow()
                      ]),
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
                          )),
                    )
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
                  selectedUnit = newValue!;
                });
              },
              items: _dropdownMeasuringUnitsItems);

  saveTask(BuildContext context) async {
    Task newTask =
        Task(deadline, false, false, selectedUnit.name, _taskTitle.text, '');
    widget.onTaskAdded(newTask);
    Navigator.of(context).pop();
  }
}
