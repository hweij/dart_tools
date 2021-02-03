import 'dart:io';

import 'shared.dart';
import 'html-templates.dart';

class ExportHTML {
  String _taskLine(Task task, int level) {
    return '''
  <div class="task-wrapper ${task.status} task-level$level">
    <div>${(level == 2) ? "- " : ""}${task.title}</div>
    <div>${task.status}</div>
    <div>${(task.start != null) ? task.start.toString() : ""}</div>
    <div>${(task.end != null) ? task.end.toString() : ""}</div>
    <div>${prio[task.priority]}</div>
    <div style="font-weight: normal;">${task.description ?? ""}</div>
  </div>
''';
  }

  void write(List<Task> planning, IOSink sink) {
    void write(String s) {
      sink.write(s);
    }

    write(HTML_START);
    for (var task in planning) {
      print(task.title);
      write('<div class="separator">&nbsp;</div>\n');

      write(_taskLine(task, 0));
      if (task.tasks != null) {
        for (var subtask in task.tasks) {
          write(_taskLine(subtask, 1));
          if (subtask.tasks != null) {
            for (var subsubtask in subtask.tasks) {
              write(_taskLine(subsubtask, 2));
            }
          }
        }
      }
    }
    write(HTML_END);
  }
}
