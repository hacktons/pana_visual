import 'dart:html' as html;

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
}
