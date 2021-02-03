const HTML_START = '''
<html>
<head>
	<title>Planning</title>

	<style>
		body {
      font-family: Arial, Helvetica, sans-serif;
      font-size: 12px;
    }
    .tasks-table {
      display: grid;
      grid-template-columns: repeat(5, max-content) auto;
    }
    .task-wrapper {
      display: contents;
    }
    .task-wrapper > div {
      padding: 0.2em;
      border: 1px solid #dddddd;
      background-color: #eeeeee;
    }
    .separator {
      grid-column: 1/-1;
    }
    .task-level0 > div {
      font-weight: bold;
    }
    .finished {
      color: #3465a4;
    }
    .header {
      display: contents;
    }
    .header > div {
      padding: 0.2em;
      font-weight: bold;
    }
	</style>

</head>

<body>

<div class="tasks-table">
  <div class="header">
    <div>Task</div>
    <div>Status</div>
    <div>Start</div>
    <div>End</div>
    <div>Priority</div>
    <div>Description</div>
  </div>
''';

const HTML_END = '''
</div>
</body>
</html>
''';
