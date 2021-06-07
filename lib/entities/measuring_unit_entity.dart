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