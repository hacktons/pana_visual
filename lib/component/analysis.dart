import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bean.dart';

class AnalysisItem extends StatelessWidget {
  final List<Choice> process;
  final List<Triple> errors;
  final List<Choice> items;

  const AnalysisItem({Key key, this.process, this.errors, this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tableRows = <TableRow>[];
    tableRows.add(
      TableRow(children: [
        Padding(
            child: Text('Health', style: TextStyle(fontSize: 18)),
            padding: EdgeInsets.all(8)),
        Padding(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: process.map((item) {
              var state = !item.checked ? "success" : "failed";
              var color = !item.checked ? "brightgreen" : "red";
              return Image.network(
                  'https://img.shields.io/badge/${item.value}-${state}-${color}');
            }).toList()
              ..addAll(errors.map((item) {
                return Image.network(
                    'https://img.shields.io/badge/${item.first}-${item.second}-${item.third}');
              }).toList(growable: false)),
          ),
          padding: EdgeInsets.only(left: 8),
        ),
      ]),
    );
    tableRows.add(TableRow(children: [
      Padding(
          child: Text('Maintenance', style: TextStyle(fontSize: 18)),
          padding: EdgeInsets.all(8)),
      Padding(
          padding: EdgeInsets.all(8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              var state = item.checked ? "true" : "false";
              var color = !item.checked ? "brightgreen" : "red";
              return Image.network(
                  'https://img.shields.io/badge/${item.value}-${state}-${color}');
            }).toList(growable: false),
          )),
    ]));
    return Table(
      border: TableBorder.all(color: Colors.black45),
      columnWidths: {1: FlexColumnWidth(9)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows,
    );
  }
}
