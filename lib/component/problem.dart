import 'package:flutter/cupertino.dart';

import 'bean.dart';
import 'widget/badge.dart';

class ProblemItem extends StatelessWidget {
  final Problem data;
  final int index;

  const ProblemItem({Key key, this.data, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Text('${index + 1}. ${data.errorCode}'),
            Badge(text: data.severity, margin: EdgeInsets.only(left: 8)),
            Badge(text: data.errorType, margin: EdgeInsets.only(left: 8)),
          ],
        ),
        Text('line ${data.line} col ${data.col}: ${data.description}'),
      ],
    );
  }
}
