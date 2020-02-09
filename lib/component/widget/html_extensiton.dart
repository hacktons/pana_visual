import 'dart:html' as html;

import 'package:flutter/cupertino.dart';

extension HoverExtension on Widget {
  static final body = html.window.document.querySelector('body');

  Widget get pointer {
    return MouseRegion(
      child: this,
      onHover: (event) => body.style.cursor = 'pointer',
      onExit: (event) => body.style.cursor = 'default',
    );
  }
}
