import 'package:pana_html/pana_html.dart' as cli;

void main(List<String> args) {
  print('call pana_html');
  cli.evaluate(['--no-web', '--strict']);
}