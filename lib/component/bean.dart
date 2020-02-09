class Choice {
  final bool checked;
  final String value;

  Choice(this.checked, this.value);
}

class Pair {
  final String first;
  final String second;

  Pair(this.first, this.second);
}

class Triple {
  final String first;
  final String second;
  final String third;

  Triple(this.first, this.second, this.third);
}

class ExpandableData {
  final String text;
  final String detail;
  bool expand = false;
  final String level;
  final String score;

  ExpandableData(this.text, {this.detail, this.score, this.level});
}

class ExpandableDetailData {
  final String text;
  final bool isFormatted;
  final double size;
  final List<Problem> codeProblems;
  bool expand = false;

  ExpandableDetailData(this.text,
      {this.isFormatted = false, this.size = 0, this.codeProblems});
}

class Problem {
  final String severity;
  final String errorType;
  final String errorCode;
  final String file;
  final int line;
  final int col;
  final description;

  Problem(
      {this.severity,
      this.errorType,
      this.errorCode,
      this.file,
      this.line,
      this.col,
      this.description});
}
