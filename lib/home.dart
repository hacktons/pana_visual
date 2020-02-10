import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/analysis.dart';
import 'component/copyright.dart';
import 'component/description.dart';
import 'component/runtime.dart';
import 'component/score.dart';
import 'component/source.dart';
import 'component/suggestion.dart';
import 'component/widget/file_picker.dart';
import 'provider/constant.dart';
import 'provider/pana.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Pana Visual'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            tooltip: 'Upload pana result(json required).',
            onPressed: handleUpload,
          ),
          PopupMenuButton(
            icon: Icon(Icons.list),
            tooltip: 'Choose sample data.',
            onSelected: handleChooseFile,
            itemBuilder: (_) => sampleJson
                .map((pair) => PopupMenuItem(
                      value: pair.first,
                      child: Text(pair.second),
                    ))
                .toList(growable: false),
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (ctx, provider, child) {
          if (!provider.hasData) {
            var args = ModalRoute.of(context).settings.arguments;
            if (args == null) {
              provider.loadData();
            }
            return child;
          }
          var report = provider.data;

          return ListView(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    _Card(
                        title: 'Runtime',
                        child: RuntimeItem(items: report.runtime)),
                    _Card(
                        title: 'Score', child: ScoreItem(items: report.scores)),
                  ]),
                ],
              ),
              _Card(
                title: 'Package',
                child: DescriptionItem(items: report.info, tags: report.tags),
              ),
              _Card(
                  title: 'Analysis',
                  child: AnalysisItem(
                      process: report.health,
                      errors: report.errors,
                      items: report.maintenance)),
              _Card(
                  title: 'Suggestion',
                  child: report.suggestions != null
                      ? SuggestionItem(items: report.suggestions)
                      : Text('No suggestion')),
              _Card(
                  title: 'Dart Files',
                  child: SourceFileItem(items: report.dartFiles)),
            ],
          );
        },
        child: Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: CopyrightBar(),
    );
  }

  void handleUpload() {
    FilePicker.pickFile().then((file) {
      if (file == null) {
        return;
      }
      Provider.of<DataProvider>(context, listen: false)
          .loadData(file: file)
          .then((_) {})
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
    });
  }

  void handleChooseFile(String result) {
    Provider.of<DataProvider>(context, listen: false).loadData(path: result);
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({Key key, this.child, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headline),
              child,
            ]),
      ),
    );
  }
}
