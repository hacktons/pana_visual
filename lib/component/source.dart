import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bean.dart';
import 'problem.dart';
import 'widget/badge.dart';
import 'widget/extension.dart';

class SourceFileItem extends StatefulWidget {
  final List<ExpandableDetailData> items;

  const SourceFileItem({Key key, this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SourceFileItem> {

  @override
  Widget build(BuildContext context) {
    var items = widget.items;
    return ExpansionPanelList(
      expansionCallback: (index, expand) {
        setState(() {
          items[index].expand = !expand;
        });
      },
      children: items.map((item) {
        var problems = <Widget>[];
        for (int i = 0; i < item.codeProblems.length; i++) {
          problems.add(ProblemItem(data: item.codeProblems[i], index: 0));
        }
        return ExpansionPanel(
          canTapOnHeader: problems.isNotEmpty,
          headerBuilder: (_, expanded) {
            var children = <Widget>[
              Text((expanded ? '- ' : '+ ') + item.text),
            ];
            if (item.isFormatted) {
              children.add(Badge(
                text: 'format',
                color: Colors.green,
                margin: EdgeInsets.only(left: 8),
              ));
            } else {
              children.add(Badge(
                text: 'format',
                color: Colors.redAccent,
                margin: EdgeInsets.only(left: 8),
              ));
            }
            if (item.codeProblems != null && item.codeProblems.isNotEmpty) {
              children.add(Badge(
                text:
                    "${item.codeProblems.length} ${item.codeProblems.length > 1 ? 'issues' : 'issue'}",
                color: Colors.redAccent,
                margin: EdgeInsets.only(left: 8),
              ));
            }
            if (item.size != null) {
              children.add(Badge(
                text: "${item.size.fileSize}",
                color: Colors.blue,
                margin: EdgeInsets.only(left: 8),
              ));
            }
            return ListTile(title: Wrap(children: children));
          },
          body: ListTile(
              subtitle: problems.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: problems,
                    )
                  : null),
          isExpanded: problems.isNotEmpty ? (item.expand ?? false) : false,
        );
      }).toList(growable: false),
    );
  }
}
