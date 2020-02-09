import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/extension.dart';
import 'widget/html_extensiton.dart';

class CopyrightBar extends StatelessWidget {
  const CopyrightBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: Text.rich(TextSpan(text: 'Generated by ', children: [
          'pana_visual v0.0.1'.linkSpan(),
        ])).pointer.click(() {
          var url = 'https://github.com/hacktons/pana_visual';
          html.window.open(url, url);
        }),
      ),
    );
  }
}
