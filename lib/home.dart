import 'dart:convert';

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
            onPressed: () {
              FilePicker.pickFile().then((file) {
                return file.text;
              }).then((json) {
                var data = jsonDecode(json);
                Provider.of<DataProvider>(context, listen: false).setData(data);
              });
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.list),
            tooltip: 'Choose sample data.',
            onSelected: (result) {
              Provider.of<DataProvider>(context, listen: false)
                  .loadData(file: result);
            },
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
          var json = provider.data;
          if (json == null) {
            var args = ModalRoute.of(context).settings.arguments;
            if (args == null) {
              provider.loadData();
            }
            return child;
          }
//          var pubspec = json['pubspec'];
//          var time = json['stats']['totalElapsed'] as num;
//          var timeSeconds = '';
//          if (time >= 1000) {
//            timeSeconds = '${time / 1000.0} ms';
//          } else {
//            timeSeconds = '$time ms';
//          }
//          var info = [
//            Pair('Name', pubspec['name'] + ' • ' + pubspec['version']),
//            Pair('Elapsed time', timeSeconds),
//            Pair('Description', pubspec['description'] ?? ''),
//            Pair('Homepage', pubspec['homepage'] ?? ''),
//          ];
//
//          var tags = (json['tags'] as List)
//              .map((t) => t.toString())
//              .toList(growable: false);
//          var runtimeInfo = json['runtimeInfo'];
//          var flutter = runtimeInfo['flutterVersions'];
//
//          var runtime = [
//            Pair('Pana', runtimeInfo['panaVersion']),
//            Pair(
//                'SDK',
//                flutter == null
//                    ? 'Dart ${runtimeInfo['sdkVersion']}'
//                    : 'Dart ${runtimeInfo['sdkVersion']} • Flutter ${flutter['frameworkVersion']} • Channel ${flutter['channel']}'),
//          ];
//
//          var scores = (json['scores'] as Map)
//              .entries
//              .toList(growable: false)
//              .map((entry) =>
//                  Pair(entry.key.toString().capitalize, entry.value.toString()))
//              .toList(growable: false);
//          var h = json['health'];
//          var health = [
//            Choice(h['analyzeProcessFailed'] as bool, 'analysis'),
//            Choice(h['formatProcessFailed'] as bool, 'format'),
//            Choice(h['resolveProcessFailed'] as bool, 'resolve'),
//          ];
//          var errors = [
//            Triple('error', h['analyzerErrorCount'].toString(), 'red'),
//            Triple('warning', h['analyzerWarningCount'].toString(), 'yellow'),
//            Triple('hint', h['analyzerHintCount'].toString(), 'orange'),
//            Triple('conflit', h['platformConflictCount'].toString(), 'red'),
//          ];
          var report = provider.data1;

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
          ;
        },
        child: Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: CopyrightBar(),
    );
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
