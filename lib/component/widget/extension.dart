import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ClickExtension on Widget {
  Widget click(GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}

extension LinkExtension on String {
  Text link({TextStyle style, double fontSize}) {
    return Text(
      this,
      style: style ??
          TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
            color: Colors.blue,
            fontSize: fontSize ?? 18,
          ),
    );
  }

  String get capitalize => this[0].toUpperCase() + this.substring(1);
}

extension ColorExtension on Color {
  String get rgb {
    return (value & 0x00ffffff).toRadixString(16);
  }
}

extension NumExtension on num {
  // https://github.com/synw/filesize/blob/master/lib/src/filesize.dart
  /// A method returns a human readable string representing a file _size
  String get fileSize {
    /**
     * [size] can be passed as number or as string
     *
     * the optional parameter [round] specifies the number
     * of digits after comma/point (default is 2)
     */
    int divider = 1024;
    int round = 2;
    var _size = this;

    if (_size < divider) {
      return "$_size B";
    }

    if (_size < divider * divider && _size % divider == 0) {
      return "${(_size / divider).toStringAsFixed(0)} KB";
    }

    if (_size < divider * divider) {
      return "${(_size / divider).toStringAsFixed(round)} KB";
    }

    if (_size < divider * divider * divider && _size % divider == 0) {
      return "${(_size / (divider * divider)).toStringAsFixed(0)} MB";
    }

    if (_size < divider * divider * divider) {
      return "${(_size / divider / divider).toStringAsFixed(round)} MB";
    }

    if (_size < divider * divider * divider * divider && _size % divider == 0) {
      return "${(_size / (divider * divider * divider)).toStringAsFixed(0)} GB";
    }

    if (_size < divider * divider * divider * divider) {
      return "${(_size / divider / divider / divider).toStringAsFixed(round)} GB";
    }

    if (_size < divider * divider * divider * divider * divider &&
        _size % divider == 0) {
      num r = _size / divider / divider / divider / divider;
      return "${r.toStringAsFixed(0)} TB";
    }

    if (_size < divider * divider * divider * divider * divider) {
      num r = _size / divider / divider / divider / divider;
      return "${r.toStringAsFixed(round)} TB";
    }

    if (_size < divider * divider * divider * divider * divider * divider &&
        _size % divider == 0) {
      num r = _size / divider / divider / divider / divider / divider;
      return "${r.toStringAsFixed(0)} PB";
    } else {
      num r = _size / divider / divider / divider / divider / divider;
      return "${r.toStringAsFixed(round)} PB";
    }
  }
}
