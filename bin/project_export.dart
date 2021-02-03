import 'dart:convert';
import 'dart:io';

import 'export-html.dart';
import 'shared.dart';

final List<Task> planning = [];

String parseMultiLine(dynamic lines) {
  if (lines == null) return null;
  if (lines is String) {
    return lines;
  } else {
    return lines.join('\n');
  }
}

Task taskFromJso(Map jso) {
  return Task(jso['title'], jso['status'],
      start: Date.fromString(jso['start']),
      end: Date.fromString(jso['end']),
      priority: jso['priority'],
      description: parseMultiLine(jso['description']));
}

void loadPlanning(String file) {
  final f = File(file);
  final txt = f.readAsStringSync();
  final jso = json.decode(txt);
  _loadTaskList(planning, jso['tasks']);
}

List<Task> _loadTaskList(List<Task> tasks, dynamic jso) {
  for (var jsoTask in jso) {
    final task = taskFromJso(jsoTask);
    final jsoSubTasks = jsoTask['tasks'];
    if (jsoSubTasks != null) {
      task.tasks = [];
      _loadTaskList(task.tasks, jsoSubTasks);
    }
    tasks.add(task);
  }
  return tasks;
}

void main(List<String> args) {
  if (args.length >= 2) {
    final inFile = args[0];
    final outFile = args[1];

    loadPlanning(inFile);

    final f = File(outFile);
    var sink = f.openWrite();

    final exportHTML = ExportHTML();
    exportHTML.write(planning, sink);

    sink.close();
  } else {
    print('Please, specify a JSON input file nd an output file');
  }
}
