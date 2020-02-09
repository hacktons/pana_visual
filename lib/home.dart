import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/analysis.dart';
import 'component/bean.dart';
import 'component/copyright.dart';
import 'component/description.dart';
import 'component/runtime.dart';
import 'component/score.dart';
import 'component/source.dart';
import 'component/suggestion.dart';
import 'component/widget/extension.dart';
import 'component/widget/file_picker.dart';
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
            padding: EdgeInsets.only(right: 16),
            tooltip: 'Upload pana result(json required).',
            onPressed: () {
              FilePicker.pickFile().then((file) {
                return file.text;
              }).then((json) {
                var data = jsonDecode(json);
                Provider.of<PanaDataProvider>(context, listen: false)
                    .setData(data);
              });
            },
          )
        ],
      ),
      body: Consumer<PanaDataProvider>(
        builder: (ctx, provider, child) {
          var json = provider.data;
          if (json == null) {
            var args = ModalRoute.of(context).settings.arguments;
            if (args == null) {
              provider.loadData();
            }
            return child;
          }
          var pubspec = json['pubspec'];
          var time = json['stats']['totalElapsed'] as num;
          var timeSeconds = '';
          if (time >= 1000) {
            timeSeconds = '${time / 1000.0} ms';
          } else {
            timeSeconds = '$time ms';
          }
          var info = [
            Pair('Name', pubspec['name'] + ' • ' + pubspec['version']),
            Pair('Elapsed time', timeSeconds),
            Pair('Description', pubspec['description'] ?? ''),
            Pair('Homepage', pubspec['homepage'] ?? ''),
          ];

          var tags = (json['tags'] as List)
              .map((t) => t.toString())
              .toList(growable: false);
          var runtimeInfo = json['runtimeInfo'];
          var flutter = runtimeInfo['flutterVersions'];

          var runtime = [
            Pair('Pana', runtimeInfo['panaVersion']),
            Pair(
                'SDK',
                flutter == null
                    ? 'Dart ${runtimeInfo['sdkVersion']}'
                    : 'Dart ${runtimeInfo['sdkVersion']} • Flutter ${flutter['frameworkVersion']} • Channel ${flutter['channel']}'),
          ];

          var scores = (json['scores'] as Map)
              .entries
              .toList(growable: false)
              .map((entry) =>
                  Pair(entry.key.toString().capitalize, entry.value.toString()))
              .toList(growable: false);
          var h = json['health'];
          var health = [
            Choice(h['analyzeProcessFailed'] as bool, 'analysis'),
            Choice(h['formatProcessFailed'] as bool, 'format'),
            Choice(h['resolveProcessFailed'] as bool, 'resolve'),
          ];
          var errors = [
            Triple('error', h['analyzerErrorCount'].toString(), 'red'),
            Triple('warning', h['analyzerWarningCount'].toString(), 'yellow'),
            Triple('hint', h['analyzerHintCount'].toString(), 'orange'),
            Triple('conflit', h['platformConflictCount'].toString(), 'red'),
          ];
          var dartFiles = (json['dartFiles'] as Map)
              .entries
              .toList(growable: false)
              .map((f) {
            return ExpandableDetailData(
              f.key,
              isFormatted: f.value['isFormatted'] as bool,
              size: f.value['size'],
              codeProblems: f.value['codeProblems'] != null
                  ? (f.value['codeProblems'] as List).map((p) {
                      return Problem(
                        severity: p['severity'],
                        errorType: p['errorType'],
                        errorCode: p['errorCode'],
                        line: p['line'],
                        col: p['col'],
                        description: p['description'],
                      );
                    }).toList(growable: false)
                  : null,
            );
          }).toList(growable: false);
          var m = json['maintenance'] as Map;
          var maintenance = m.entries
              .toList(growable: false)
              .where((e) => e.value is bool)
              .map((e) => Choice(e.value as bool, e.key))
              .toList(growable: false);

          var hs = h['suggestions'];
          var ms = m['suggestions'];
          var ss = [];
          if (hs != null) {
            ss.addAll(hs as List);
          }
          if (ms != null) {
            ss.addAll(ms as List);
          }
          var suggestions = ss.isNotEmpty
              ? ss.map((s) {
                  return ExpandableData(s['title'],
                      detail: s['description'],
                      score: s['score'].toString(),
                      level: s['level']);
                }).toList(growable: false)
              : null;

          return ListView(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    _Card(title: 'Runtime', child: RuntimeItem(items: runtime)),
                    _Card(title: 'Score', child: ScoreItem(items: scores)),
                  ]),
                ],
              ),
              _Card(
                title: 'Package',
                child: DescriptionItem(items: info, tags: tags),
              ),
              _Card(
                  title: 'Analysis',
                  child: AnalysisItem(
                      process: health, errors: errors, items: maintenance)),
              _Card(
                  title: 'Suggestion',
                  child: suggestions != null
                      ? SuggestionItem(items: suggestions)
                      : Text('No suggestion')),
              _Card(
                  title: 'Dart Files', child: SourceFileItem(items: dartFiles)),
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
