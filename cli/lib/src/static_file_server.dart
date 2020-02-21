import 'dart:io';

import 'package:http_server/http_server.dart';

/// static file server
void serve(String root) async {
  var staticFiles = VirtualDirectory(root);
  staticFiles.allowDirectoryListing = true;
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(File(indexUri.toFilePath()), request);
  };

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  print('Pana report are served at http://127.0.0.1:${server.port}#/home');
  await server.forEach(staticFiles.serveRequest);
}
