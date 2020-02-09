import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bean.dart';
import 'widget/badge.dart';

class SuggestionItem extends StatefulWidget {
  final List<ExpandableData> items;

  const SuggestionItem({Key key, this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SuggestionItem> {
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
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (_, expanded) {
            var children = <Widget>[
              Text(item.text),
            ];
            if (item.level != null && item.level.isNotEmpty) {
              children.add(Badge(
                text: item.level,
                color: Colors.orange,
                margin: EdgeInsets.only(left: 8),
              ));
            }
            if (item.score != null && item.score.isNotEmpty) {
              children.add(Badge(
                text: "-" + item.score,
                color: Colors.redAccent,
                margin: EdgeInsets.only(left: 8),
              ));
            }
            return ListTile(title: Wrap(children: children));
          },
          body: ListTile(subtitle: Text(item.detail.trim()), onTap: () {}),
          isExpanded: item.expand ?? false,
        );
      }).toList(growable: false),
    );
  }
}
