import 'package:flutter/material.dart';

class PatternBackgroundWidget extends StatefulWidget {
  final List<Duration> pattern;

  PatternBackgroundWidget({required this.pattern});

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
      await Future.delayed(widget.pattern[currentIndex]);
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.pattern.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentIndex % 2 == 0 ? Colors.black : Colors.white,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Stop'),
        ),
      ),
    );
  }
}
