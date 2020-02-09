import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bean.dart';

class ScoreItem extends StatelessWidget {
  final List<Pair> items;

  const ScoreItem({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        border: TableBorder.all(color: Colors.black45),
        columnWidths: {1: FlexColumnWidth(4)},
        children: items.map((item) {
          return TableRow(children: [
            Padding(
              child: Text(item.first, style: TextStyle(fontSize: 18)),
              padding: EdgeInsets.all(8),
            ),
            Padding(
              child: Text(item.second,
                  style: _parse(item) >= 100
                      ? TextStyle(fontSize: 18, color: Colors.green)
                      : TextStyle(fontSize: 18, color: Colors.redAccent)),
              padding: EdgeInsets.all(8),
            )
          ]);
        }).toList(growable: false),
      ),
    );
  }

  double _parse(Pair item) => double.tryParse(item.second) ?? 0;
}
