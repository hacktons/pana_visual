import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'src/static_file_server.dart';
import 'src/util.dart';

/// generate html report and deploy as local service
Future<void> main(List<String> args) async {
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
      return;
    }
  }
  print('analyze project health and maintenance...');
  var report = await Process.run('pana', ['--scores', '--source', 'path', '.']);
  var result = report.stdout;
  try {
    var json = jsonDecode(result);
    if (json != null) {
      print('analyze completed');
    }
  } catch (e) {
    print('analyze failed');
    print(report.stderr);
    return;
  }
  var exist = await Directory('pana_visual').exists();
  if (!exist) {
    Directory('pana_visual').createSync();
  }
  final tar = Platform.script.resolve('web.tar.gz').toFilePath();
  extractTarGzip(tar, 'pana_visual');
  // update data.json
  File(join(
    'pana_visual',
    'assets',
    'assets',
    'data.json',
  )).writeAsStringSync(result);
  await serve('pana_visual');
  print('Terminate as you like');
}
