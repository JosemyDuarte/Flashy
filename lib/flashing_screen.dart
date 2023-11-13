import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Flashing Screen");
  }

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logEvent(
      name: 'flashing',
      parameters: <String, dynamic>{
        'vibrate': widget.settings.vibrate.toString(),
        'onColor': widget.settings.onColor.toString(),
        'offColor': widget.settings.offColor.toString(),
        'patternLength': widget.patterns.length,
      },
    );

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
            FirebaseAnalytics.instance.logEvent(
              name: 'flashing_stopped_by_button',
            );
            Vibration.cancel();
            Navigator.pop(context);
          },
          child: const Text('Stop'),
        ),
      ),
    );
  }
}
