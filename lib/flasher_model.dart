import 'package:flutter/material.dart';

class FlasherModel extends ChangeNotifier {
  bool vibrate;

  Color offColor;

  Color onColor;

  List<Duration> _pattern = [];

  FlasherModel({
    this.vibrate = false,
    this.offColor = Colors.black,
    this.onColor = Colors.white,
  });

  void updateSettings({
    bool? vibrate,
    Color? offColor,
    Color? onColor,
  }) {
    this.vibrate = vibrate ?? this.vibrate;
    this.offColor = offColor ?? this.offColor;
    this.onColor = onColor ?? this.onColor;

    notifyListeners();
  }

  void overwritePatterns(List<Duration> newPattern) {
    _pattern = newPattern;

    notifyListeners();
  }

  void addPattern(Duration newPattern) {
    _pattern.add(newPattern);

    notifyListeners();
  }

  List<Duration> get pattern => _pattern;
}