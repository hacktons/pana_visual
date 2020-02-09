// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pana_web/component/widget/extension.dart';

void main() {
  test("Extension test Color.rgb ", () {
    expect(Colors.red.rgb, 'f44336');
    expect(Color(0xFF123456).rgb, '123456');
  });
}
