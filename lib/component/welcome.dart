import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pana.dart';
import 'widget/file_picker.dart';

class WelcomeItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WelcomeItem> {

  @override
  Widget build(BuildContext context) {
    var headlineStyle = Theme.of(context).textTheme.headline;
    return Column(
      children: <Widget>[
        Text('Pana Visual', style: Theme.of(context).textTheme.display3),
        Padding(padding: EdgeInsets.only(bottom: 8)),
        Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: Text(
              'Preview the health and quality of a Dart/Flutter package before publish.',
              style: Theme.of(context).textTheme.subtitle),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              child: Text('Sample', style: headlineStyle),
              onPressed: () => jump2Home(),
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
            OutlineButton(
              child: Text('Upload', style: headlineStyle),
              onPressed: () => _uploadJson(),
            ),
          ],
        ),
      ],
    );
  }

  void _uploadJson() async {
    var file = await FilePicker.pickFile();
    if (file == null) {
      // nothing selected
      debugPrint('no file return');
      return;
    }
    debugPrint('file =${file.name}');
    var success = await Provider.of<DataProvider>(context, listen: false)
        .loadData(file: file)
        .catchError((_) {
      debugPrint("$_");
      var message = _ is FormatException
          ? '${file.name} can not be parsed as JSON'
          : 'Parse json file failed';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
    if (success != null && success == true) {
      jump2Home();
    }
  }

  void jump2Home() {
    Navigator.of(context).pushReplacementNamed('/home', arguments: true);
  }
}
