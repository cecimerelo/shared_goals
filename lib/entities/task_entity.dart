class Task {
  DateTime deadline;
  bool done;
  bool isRoot;
  String measuredIn;
  String name;
  String parentId;

  Task(this.deadline, this.done, this.isRoot, this.measuredIn, this.name,
      this.parentId);
}
