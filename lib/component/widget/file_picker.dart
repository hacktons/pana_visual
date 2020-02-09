import 'dart:html' as html;
import 'dart:html';

class FilePicker {
  static Future<File> pickFile() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input..accept = 'application/json';
    input.click();
    await input.onChange.first;
    if (input.files.isEmpty) return null;
    return input.files[0];
  }
}

extension FileExtension on File {
  Future<String> get text async {
    final reader = html.FileReader();
    reader.readAsText(this);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    return encoded;
  }
}
