import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../component/bean.dart';
import '../component/widget/extension.dart';
import '../component/widget/html_extensiton.dart';

class DataProvider extends ChangeNotifier {
  Map<String, dynamic> _jsonData;
  ReportData _data;

  Future<bool> loadData(
      {String path = 'assets/pana-0.13.5.json', html.File file}) async {
    var task = file != null ? file.text : rootBundle.loadString(path);
    var json = await task;
    _jsonData = jsonDecode(json);
    _data = _parse(_jsonData);
    notifyListeners();
    return true;
  }

  bool get hasData {
    return _jsonData != null;
  }

  ReportData get data {
    return _data;
  }

  ReportData _parse(Map<String, dynamic> json) {
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

    var tags =
        (json['tags'] as List).map((t) => t.toString()).toList(growable: false);
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

    var dartFiles =
        (json['dartFiles'] as Map).entries.toList(growable: false).map((f) {
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

    return ReportData(
      info: info,
      tags: tags,
      runtime: runtime,
      scores: scores,
      health: health,
      errors: errors,
      dartFiles: dartFiles,
      maintenance: maintenance,
      suggestions: suggestions,
    );
  }
}

class ReportData {
  final List<Pair> info;
  final List<String> tags;
  final List<Pair> runtime;
  final List<Pair> scores;
  final List<Choice> health;
  final List<Triple> errors;
  final List<ExpandableDetailData> dartFiles;
  final List<Choice> maintenance;
  final List<ExpandableData> suggestions;

  const ReportData({
    this.info,
    this.tags,
    this.runtime,
    this.scores,
    this.health,
    this.errors,
    this.dartFiles,
    this.maintenance,
    this.suggestions,
  });
}
