import 'package:flutter/material.dart';
import 'package:test/test.dart';

import '../lib/flasher_model.dart';

void main() {
  group('FlasherModel Tests', () {
    test('Default constructor values', () {
      final flasherModel = FlasherModel();

      expect(flasherModel.vibrate, false);
      expect(flasherModel.offColor, equals(Colors.black));
      expect(flasherModel.onColor, equals(Colors.white));
      expect(flasherModel.pattern, isEmpty);
    });

    test('Update settings', () {
      final flasherModel = FlasherModel();
      flasherModel.updateSettings(
          vibrate: true, offColor: Colors.red, onColor: Colors.blue);

      expect(flasherModel.vibrate, true);
      expect(flasherModel.offColor, equals(Colors.red));
      expect(flasherModel.onColor, equals(Colors.blue));
    });

    test('Overwrite patterns', () {
      final flasherModel = FlasherModel();
      final newPattern = [
        Duration(milliseconds: 500),
        Duration(milliseconds: 1000)
      ];

      flasherModel.overwritePatterns(newPattern);

      expect(flasherModel.pattern, equals(newPattern));
    });

    test('Add pattern', () {
      final flasherModel = FlasherModel();
      final newPattern = Duration(milliseconds: 500);

      flasherModel.addPattern(newPattern);

      expect(flasherModel.pattern, contains(newPattern));
    });

    test('Notify listeners', () {
      final flasherModel = FlasherModel();
      bool listenerCalled = false;

      flasherModel.addListener(() {
        listenerCalled = true;
      });

      flasherModel.notifyListeners();

      expect(listenerCalled, true);
    });
  });
}
