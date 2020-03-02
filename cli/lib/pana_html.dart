import 'dart:async';
import 'dart:io';

import 'package:pana_html/src/result.dart';

import 'src/runner.dart';

/// entry point of application
Future<void> main(List<String> args) async {
  var result = await evaluate(args);
  var state = result.success ? 'success' : 'failed';
  print('Evaluate:$state, ${result.message}');
  if (!result.success) {
    exit(1);
  }
}

/// run project evaluation
/// args example: ['--no-web', '--strict']
Future<EvaluateResult> evaluate(List<String> args) async {
  return ProjectRunner(args).evaluate();
}
