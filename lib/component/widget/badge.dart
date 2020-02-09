import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extension.dart';

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const Badge(
      {Key key, this.text, this.color = Colors.red, this.padding, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(right: 8, left: 8),
      padding: padding,
//      decoration: BoxDecoration(
//        color: color ?? Colors.redAccent,
//        borderRadius: BorderRadius.circular(2),
//      ),
      child: Image.network('https://img.shields.io/badge/$text-${color.rgb}'),
    );
  }
}
