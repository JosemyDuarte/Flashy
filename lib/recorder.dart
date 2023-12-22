import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pattern_flash/flashing_screen.dart';
import 'package:vibration/vibration.dart';

import 'flasher_model.dart';

class RecorderWidget extends StatefulWidget {
  const RecorderWidget({
    Key? key,
    required this.title,
    required this.model,
  }) : super(key: key);

  final String title;
  final FlasherModel model;

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  //List<Duration> _durations = [];
  bool _isRecording = false;

  DateTime lastPress = DateTime.timestamp();
  DateTime previousPress = DateTime.timestamp();
  String centerText = 'Tap here to record your pattern';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Recorder tab");
  }

  void _recordPress() {
    setState(() {
      if (widget.model.vibrate) {
        Vibration.vibrate(duration: 250, amplitude: 50);
      }

      if (!_isRecording) {
        _isRecording = true;
        centerText = 'Recording...';
        lastPress = DateTime.timestamp();

        return;
      }

      previousPress = lastPress;
      lastPress = DateTime.timestamp();

      widget.model.addPattern(lastPress.difference(previousPress));
    });
  }

  // clean up the presses and durations
  void _clearPresses() {
    FirebaseAnalytics.instance.logEvent(
      name: 'recorder_clear',
    );

    setState(() {
      _isRecording = false;
      centerText = 'Tap here to record your pattern';
      widget.model.overwritePatterns([]);
    });
  }

  // stop recording
  void _stopRecording() {
    FirebaseAnalytics.instance.logEvent(
      name: 'recorder_stop',
    );

    setState(() {
      _isRecording = false;
      if (widget.model.pattern.length > 0) {
        centerText =
            'Hit ▶️ to reproduce your pattern or tap here to record again';
      } else
        centerText = 'Tap here to record your pattern';
    });
  }

  void _playRecording() {
    FirebaseAnalytics.instance.logEvent(
      name: 'recorder_play',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatternBackgroundWidget(
            settings: widget.model, patterns: widget.model.pattern),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: _recordPress,
              splashColor: widget.model.offColor,
              splashFactory: InkSplash.splashFactory,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                'Flashes: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${widget.model.pattern.length}'),
            ],
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: <Widget>[
            TextButton(
              onPressed: widget.model.pattern.length > 0 ? _clearPresses : null,
              child: const Icon(Icons.delete),
            ),
            Spacer(),
            TextButton(
              onPressed: !_isRecording && widget.model.pattern.length > 0
                  ? _playRecording
                  : null,
              child: const Icon(Icons.play_arrow),
            ),
            Spacer(),
            TextButton(
              onPressed: _isRecording ? _stopRecording : null,
              child: const Icon(Icons.stop),
            ),
          ],
        ),
      ],
    );
  }
}
