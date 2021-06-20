import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/entities/resource.dart';

class ResourceWidget extends StatefulWidget {
  final ResourceEntity resource;

  ResourceWidget({required this.resource});

  factory ResourceWidget.fromDocument(DocumentSnapshot doc) {
    ResourceEntity goalEntity = ResourceEntity.fromDocument(doc);
    return ResourceWidget(resource: goalEntity);
  }

  @override
  _ResourceWidgetState createState() =>
      _ResourceWidgetState(resource: this.resource);
}

class _ResourceWidgetState extends State<ResourceWidget> {
  final ResourceEntity resource;

  _ResourceWidgetState({
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    IconData resourceIcon = _getIcon(resource.measuringUnitName);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Card(
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(resourceIcon, size: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${resource.resource}', style: TextStyle(fontSize: 21)),
            )
      ])),
    );
  }

  IconData _getIcon(String unitName) {
    if (unitName == 'books') {
      return Icons.auto_stories;
    } else if (unitName == 'courses') {
      return Icons.school;
    }
    return Icons.access_time;
  }
}
