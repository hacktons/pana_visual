import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:pana_html/src/result.dart';
import 'package:path/path.dart';

import 'static_file_server.dart';
import 'util.dart';

/// Runner to check evaluate project
class ProjectRunner {
  /// command line parameters
  final List<String> args;
  bool _webServer;
  bool _strictMode;
  bool _help;
  final _parser = ArgParser()
    ..addFlag(
      'web',
      defaultsTo: true,
      negatable: true,
      help: 'Deoply local server to serve html/css',
    )
    ..addFlag(
      'strict',
      defaultsTo: false,
      negatable: true,
      help: 'Strict will breakdown the process if score are lower than 100',
    )
    ..addFlag('help',
        abbr: 'h',
        defaultsTo: false,
        negatable: false,
        help: 'Print this usage information.');

  /// Construct a runner according to the cli parameters
  ProjectRunner(this.args) {
    var argResults = _parser.parse(args);
    _webServer = argResults['web'];
    _strictMode = argResults['strict'];
    _help = argResults['help'];
  }

  Future<bool> _envCheck() async {
    print('checking if pana installed...');
    var pubConfigured = await checkCommand('pub', ['version'], 'Pub ');
    var installed = await checkPana(pubConfigured);
    if (!installed) {
      print('install pana first');
      if (pubConfigured) {
        await Process.run('pub', ['global', 'activate', 'pana']);
      } else {
        await Process.run('flutter', ['pub', 'global', 'activate', 'pana']);
      }
      installed = await checkPana(pubConfigured);
      if (!installed) {
        print('Please install pana manually: pub global activate pana');
        return false;
      }
    }
    return true;
  }

  /// start evaluate
  Future<EvaluateResult> evaluate() async {
    if (_help) {
      print(_parser.usage);
      exit(0);
    }

    var success = await _envCheck();
    if (!success) {
      return EvaluateResult(
          success: false, message: 'pana is not configured or installed');
    }
    print('analyze project health and maintenance...');
    var report =
        await Process.run('pana', ['--scores', '--source', 'path', '.']);
    var result = report.stdout;
    var json;
    try {
      json = jsonDecode(result);
    } catch (e) {
      print('Exception:\n${e.toString()}');
      print(report.stderr);
      return EvaluateResult(
          success: false, message: 'pana failed to evaluate project');
    }
    if (json != null) {
      print('analyze completed');
    }
    var url = '';
    if (_webServer) {
      url = await _genHtml(result);
    }
    var scores = json['scores'];
    var health = scores != null ? scores['health'] : 0;
    var maintenance = scores != null ? scores['maintenance'] : 0;
    if (_strictMode) {
      if (health < 100 || maintenance < 100) {
        print(result);
        return EvaluateResult(
          success: false,
          message: 'health:$health, maintenance=$maintenance',
          url: url,
        );
      }
    }

    return EvaluateResult(
      success: true,
      message: 'health:$health, maintenance=$maintenance',
      url: url,
    );
  }
}

/// generate html report and deploy as local service
Future<String> _genHtml(String result) async {
  var exist = await Directory('pana_visual').exists();
  if (!exist) {
    Directory('pana_visual').createSync();
  }
  await extractTarGzip('package:pana_html/web.tar.gz', 'pana_visual');
  // update data.json
  var dataFile = join('pana_visual', 'assets', 'assets', 'data.json');
  File(dataFile).writeAsStringSync(result);
  var url = await serve('pana_visual');
  print('Terminate as you like');
  return url;
}
