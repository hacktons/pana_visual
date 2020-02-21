import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart';

/// check if pana installed
Future<bool> checkPana(bool pubConfigured) async {
  var installed = false;
  var cmd = pubConfigured ? 'pub' : 'flutter';
  var args = pubConfigured ? ['global', 'list'] : ['pub', 'global', 'list'];
  installed = await checkCommand(cmd, args, 'pana ');
  return installed;
}

/// check if the cmd output match with keyword
Future<bool> checkCommand(String cmd, List<String> args, String keyword) async {
  var result = await Process.run(cmd, args);
  var data = result.stdout as String;
  return data.contains(keyword);
}

/// extract the file.tar.gz file into destination
void extractTarGzip(String path, String des) {
  var bytes = File(path).readAsBytesSync();
  var gz = GZipDecoder().decodeBytes(bytes);
  var archive = TarDecoder().decodeBytes(gz);
  for (var file in archive) {
    var filename = file.name;
    if (file.isFile) {
      List<int> data = file.content;
      File(join(des, filename))
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(join(des, filename))..create(recursive: true);
    }
  }
}
