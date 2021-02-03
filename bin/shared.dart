const prio = ['opt', 'low', 'med', 'high'];

class Task {
  Date start;
  Date end;
  String title;
  String description;
  int priority;
  List<Task> tasks;
  String status;
  Task(
    this.title,
    this.status, {
    this.start,
    this.end,
    this.description,
    this.tasks,
    this.priority = 2,
  });
}

class Date {
  final int year;
  final int month;
  final int day;

  const Date(this.year, this.month, this.day);

  static Date fromString(String s) {
    if (s != null) {
      final parts = s.split('-').map((s) => int.parse(s)).toList();
      return Date(parts[0], parts[1], parts[2]);
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";
  }
}
