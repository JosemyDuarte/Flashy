import 'package:flutter/material.dart';
import 'package:pattern_flash/settings.dart';
import 'package:vibration/vibration.dart';

class PatternBackgroundWidget extends StatefulWidget {
  final FlasherModel settings;
  List<Duration> patterns = [];

  PatternBackgroundWidget({required this.settings, required this.patterns});

  @override
  _PatternBackgroundWidgetState createState() =>
      _PatternBackgroundWidgetState();
}

class _PatternBackgroundWidgetState extends State<PatternBackgroundWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startPatternUpdates();
  }

  void _startPatternUpdates() async {
    while (mounted) {
      if (widget.settings.vibrate) {
        currentIndex % 2 == 0
            ? Vibration.vibrate(
                duration: widget.patterns[currentIndex].inMilliseconds)
            : Vibration.cancel();
      }

      await Future.delayed(widget.patterns[currentIndex]);
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.patterns.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentIndex % 2 == 0
          ? widget.settings.offColor
          : widget.settings.onColor,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Vibration.cancel();
            Navigator.pop(context);
          },
          child: const Text('Stop'),
        ),
      ),
    );
  }
}
