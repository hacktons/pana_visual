import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/cupertino.dart';

class FilePicker {
  /// Better used inside a StatefulWidget, or the onChange event may not be fired
  static Future<html.File> pickFile({String mime = 'application/json'}) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input..accept = mime;
    input.click();
    await input.onChange.first;
    if (input.files.isEmpty) {
      return null;
    }
    return input.files[0];
  }

  static Future<html.File> pickDirectory(
      {String mime = 'application/json'}) async {
    debugPrint('support = ${html.FileSystem.supported}');
    var input = html.Element.html(
      '<!--suppress HtmlUnknownAttribute --><input type="file" webkitdirectory directory/>',
      validator: html.NodeValidatorBuilder()
        ..allowElement('input', attributes: ['webkitdirectory', 'directory'])
        ..allowHtml5()
    );
    input.click();
    await input.onChange.first;
    var files = (input as html.InputElement).files;
    if (files == null || files.isEmpty) {
      return null;
    }
    for(var f in files) {
      debugPrint("${f.relativePath}");
    }
    return files[0];
  }


}

extension InputExtension on html.FileUploadInputElement {
  bool get webkitdirectory {
    return true;
  }

  bool get directory {
    return true;
  }
}
