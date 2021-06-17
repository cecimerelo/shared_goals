class Task {
  DateTime deadline;
  bool done;
  String measuredIn;
  String name;
  String totalEffort;
  String parentID;
  List<String> resourcesReference;

  Task(this.deadline, this.done, this.measuredIn, this.name, this.totalEffort,
      this.parentID, this.resourcesReference);
}
