import 'dart:io';

import 'package:excel/excel.dart';

import 'shared.dart';

class ExportExcel {
  final normalStyle = CellStyle(
      backgroundColorHex: '#EEEEEE',
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Top);
  final boldStyle = CellStyle(
      backgroundColorHex: '#EEEEEE',
      fontFamily: getFontFamily(FontFamily.Arial),
      bold: true,
      verticalAlign: VerticalAlign.Top);
  final normalFinished = CellStyle(
      backgroundColorHex: '#EEEEEE',
      fontColorHex: '#3465a4',
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Top);
  final boldFinished = CellStyle(
      backgroundColorHex: '#EEEEEE',
      fontColorHex: '#3465a4',
      fontFamily: getFontFamily(FontFamily.Arial),
      bold: true,
      verticalAlign: VerticalAlign.Top);
  final descriptionStyle = CellStyle(
      backgroundColorHex: '#EEEEEE',
      fontFamily: getFontFamily(FontFamily.Arial),
      textWrapping: TextWrapping.WrapText,
      verticalAlign: VerticalAlign.Top);
  final titleStyle =
      CellStyle(fontFamily: getFontFamily(FontFamily.Arial), bold: true);

  void _writeTaskLine(Sheet sheet, int row, Task task, int level) {
    final p = (task?.priority ?? 2).clamp(0, 3);
    final style = (task.status == 'finished')
        ? (level == 0)
            ? boldFinished
            : normalFinished
        : (level == 0)
            ? boldStyle
            : normalStyle;
    _writeCell(
        sheet, row, 0, style, (level == 2) ? '- ${task.title}' : task.title);
    _writeCell(sheet, row, 1, style, task.status ?? '');
    _writeCell(sheet, row, 2, style, task.start?.toString() ?? '');
    _writeCell(sheet, row, 3, style, task.end?.toString() ?? '');
    _writeCell(sheet, row, 4, style, prio[p]);
    _writeCell(sheet, row, 5, normalStyle, task.description ?? '');
  }

  void _writeCell(Sheet sheet, int row, int col, CellStyle style, String text) {
    final cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
    cell.cellStyle = style;
    cell.value = text;
  }

  Future<void> write(List<Task> planning, String fname) async {
    final f = File(fname);

    Excel excel;

    excel = Excel.createExcel();

    var sheetName = await excel.getDefaultSheet();
    if (sheetName != 'planning') {
      excel.rename(sheetName, 'planning');
    }
    final sheet = excel.sheets['planning'];

    var row = 0;
    _writeCell(sheet, row, 0, titleStyle, 'Planning');
    row += 2;
    for (var task in planning) {
      print(task.title);

      _writeTaskLine(sheet, row, task, 0);
      row++;
      if (task.tasks != null) {
        for (var subtask in task.tasks) {
          _writeTaskLine(sheet, row, subtask, 1);
          row++;
          if (subtask.tasks != null) {
            for (var subsubtask in subtask.tasks) {
              _writeTaskLine(sheet, row, subsubtask, 2);
              row++;
            }
          }
        }
      }
      row++; // Skip a row
    }

    final onValue = await excel.encode();
    await f.writeAsBytes(onValue);
  }
}
