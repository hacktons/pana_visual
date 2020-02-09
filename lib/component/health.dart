import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bean.dart';

class HealthItem extends StatelessWidget {
  final List<Choice> items;
  final List<Triple> items2;

  const HealthItem({Key key, this.items, this.items2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Table(
          border: TableBorder.all(color: Colors.black45),
          columnWidths: {1: FlexColumnWidth(4)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Padding(
                  child: Text('检测', style: TextStyle(fontSize: 18)),
                  padding: EdgeInsets.all(8)),
              Padding(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    var state = !item.checked ? "passed" : "failed";
                    var color = !item.checked ? "brightgreen" : "red";
                    return Image.network(
                        'https://img.shields.io/badge/${item.value}-${state}-${color}');
                  }).toList(growable: false),
                ),
                padding: EdgeInsets.only(left: 8),
              ),
            ]),
            TableRow(
              children: [
                Padding(
                    child: Text('结果', style: TextStyle(fontSize: 18)),
                    padding: EdgeInsets.all(8)),
                Padding(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items2.map((item) {
                      return Image.network(
                          'https://img.shields.io/badge/${item.first}-${item.second}-${item.third}');
                    }).toList(growable: false),
                  ),
                  padding: EdgeInsets.only(left: 8),
                ),
              ],
            )
          ],
        ));
  }
}
