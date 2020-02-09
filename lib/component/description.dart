import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'bean.dart';
import 'widget/html_extensiton.dart';
import 'widget/extension.dart';

class DescriptionItem extends StatefulWidget {
  final List<Pair> items;
  final List<String> tags;

  const DescriptionItem({Key key, this.items, this.tags}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<DescriptionItem> {
  List<TapGestureRecognizer> _recognizers = [];

  @override
  Widget build(BuildContext context) {
    var tableRows = widget.items.map((item) {
      var url = item.second;
      var isUrl = url != null && url.startsWith("http://") ||
          url.startsWith("https://");

      Widget content = isUrl
          ? item.second.link(fontSize: 18).pointer.click(() {
              html.window.open(url, url);
            })
          : Text(item.second, style: TextStyle(fontSize: 18));
      return TableRow(children: [
        Padding(
          child: Text(item.first, style: const TextStyle(fontSize: 18)),
          padding: EdgeInsets.all(8),
        ),
        Padding(child: content, padding: EdgeInsets.all(8))
      ]);
    }).toList();
    tableRows.add(TableRow(children: [
      Padding(
        child: Text('Platform', style: const TextStyle(fontSize: 18)),
        padding: EdgeInsets.all(8),
      ),
      Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.tags.map((tag) {
            return Image.network(
              tag2badge(tag),
            );
          }).toList(growable: false),
        ),
      )
    ]));
    return Table(
      border: TableBorder.all(color: Colors.black45),
      columnWidths: {1: FlexColumnWidth(9)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows,
    );

//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        ...widget.items.map((item) {
//          var url = item.second;
//          var isUrl = url != null && url.startsWith("http://") ||
//              url.startsWith("https://");
//          return Text.rich(
//            TextSpan(text: item.first + ": ", children: [
//              TextSpan(
//                text: item.second,
//                style: isUrl
//                    ? TextStyle(
//                        decoration: TextDecoration.underline,
//                        decorationColor: Colors.blue,
//                        color: Colors.blue,
//                      )
//                    : null,
//                recognizer: isUrl ? newRecognizer(url) : null,
//              )
//            ]),
//            style: TextStyle(fontSize: 18),
//          );
//        }).toList(growable: false),
//        //Padding(padding: EdgeInsets.only(bottom: 8)),
//        Wrap(
//          spacing: 8,
//          runSpacing: 8,
//          children: widget.tags.map((tag) {
//            return Image.network(
//              tag2badge(tag),
//            );
//          }).toList(growable: false),
//        )
//      ],
//    );
  }

  String tag2badge(String tag) {
    var array = tag.split(":");
    var t = array[0];
    var m = array[1];
    if (m.contains('-')) {
      m = m.replaceAll('-', '');
    }
    return "https://img.shields.io/badge/$t-$m-blue";
  }

  TapGestureRecognizer newRecognizer(String url) {
    var r = TapGestureRecognizer()
      ..onTap = () {
        html.window.open(url, url);
      };
    _recognizers.add(r);
    return r;
  }

  @override
  void dispose() {
    _recognizers?.forEach((r) {
      r.dispose();
    });
    super.dispose();
  }
}
