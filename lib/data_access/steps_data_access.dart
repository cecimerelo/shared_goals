import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference stepsReference =
    FirebaseFirestore.instance.collection('steps');

getStepsReference() {
  return stepsReference;
}

Future<QuerySnapshot<Object?>> getAllSteps() async {
  final QuerySnapshot stepsSnapshot = await stepsReference.get();
  return stepsSnapshot;
}

class Step {
  bool _done;

  bool get done => _done;

  set done(bool done) {
    _done = done;
  }

  DateTime _deadline;

  DateTime get deadline => _deadline;

  set deadline(DateTime deadline) {
    _deadline = deadline;
  }
  bool _isRoot;

  bool get isRoot => _isRoot;

  set isRoot(bool isRoot) {
    _isRoot = isRoot;
  }
  String name;
  String parentId;
  List resources;

  Step(this._done, this._deadline, this._isRoot, this.name, this.parentId,
      this.resources);

}
