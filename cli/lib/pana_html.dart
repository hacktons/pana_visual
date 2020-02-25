import 'dart:async';
import 'dart:io';

import 'src/runner.dart';

Future<void> main(List<String> args) async {
  var runner = ProjectRunner(args);
  var result = await runner.evaluate();
  var state = result.success ? 'success' : 'failed';
  print('Evaluate:$state, ${result.message}');
  if(!result.success){
    exit(1);
  }
}
