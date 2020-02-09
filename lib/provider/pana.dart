import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PanaDataProvider extends ChangeNotifier {
  Map<String, dynamic> data;

  void loadData() {
    rootBundle.loadString('assets/pana.json').then((json) {
      data = jsonDecode(json);
      notifyListeners();
    });
  }

  void setData(Map<String, dynamic> json) {
    data = json;
    notifyListeners();
  }
}
