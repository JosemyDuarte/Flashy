import 'package:flutter/material.dart';
import 'package:metronome/FlashingScreen.dart';
import 'package:metronome/Settings.dart';

class RecorderWidget extends StatefulWidget {
  final String title;
  final FlasherSettings settings;

  const RecorderWidget({required this.title, required this.settings});

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  List<Duration> _durations = [];
  bool _isRecording = false;

  DateTime lastPress = DateTime.timestamp();
  DateTime previousPress = DateTime.timestamp();
  String centerText = 'Tap to start recording';

  void _recordPress() {
    setState(() {
      if (!_isRecording) {
        _isRecording = true;
        centerText = 'Recording...';
        lastPress = DateTime.timestamp();

        return;
      }

      previousPress = lastPress;
      lastPress = DateTime.timestamp();

      _durations.add(lastPress.difference(previousPress));
    });
  }

  // clean up the presses and durations
  void _clearPresses() {
    setState(() {
      _isRecording = false;
      centerText = 'Tap to start recording';
      _durations = [];
    });
  }

  // stop recording
  void _stopRecording() {
    setState(() {
      _isRecording = false;
      if (_durations.length > 0) {
        centerText = 'Hit play to start flashing\n\n or tap to record again';
      } else
        centerText = 'Tap to start recording';
    });
  }

  void _playRecording() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatternBackgroundWidget(settings: widget.settings, patterns: _durations),
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
              child: Center(
                child: Text(
                  '${centerText}',
                  style: Theme.of(context).textTheme.headlineMedium,
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
              Text('${_durations.length}'),
            ],
          ),
          OverflowBar(
            children: [
              for (var i = 0; i < _durations.length; i++)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: i % 2 == 0 ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          )
        ],
      ),
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: <Widget>[
            TextButton(
              onPressed: _durations.length > 0 ? _clearPresses : null,
              child: const Icon(Icons.bolt),
            ),
            Spacer(),
            TextButton(
              onPressed: !_isRecording && _durations.length > 0
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
