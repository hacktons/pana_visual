import 'dart:html';

import 'package:flutter/cupertino.dart';

extension HoverExtension on Widget {
  static final body = window.document.querySelector('body');

  Widget get pointer {
    return MouseRegion(
      child: this,
      onHover: (event) => body.style.cursor = 'pointer',
      onExit: (event) => body.style.cursor = 'default',
    );
  }
}

extension FileExtension on File {
  Future<String> get text async {
    final reader = FileReader();
    reader.readAsText(this);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    return encoded;
  }
}
