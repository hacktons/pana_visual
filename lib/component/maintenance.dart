import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bean.dart';

class MaintenanceItem extends StatelessWidget {
  final List<Choice> items;

  const MaintenanceItem({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          var state = item.checked ? "true" : "false";
          var color = !item.checked ? "brightgreen" : "red";
          return Image.network(
              'https://img.shields.io/badge/${item.value}-${state}-${color}');
        }).toList(growable: false),
      ),
    );
  }
}
