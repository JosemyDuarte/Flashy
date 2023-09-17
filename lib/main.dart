import 'package:flutter/material.dart';
import 'package:metronome/FlashingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metronome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Metronome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        builder: (context) => PatternBackgroundWidget(pattern: _durations),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flasher',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
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
          TextButton(
            onPressed: _durations.length > 0 ? _clearPresses : null,
            child: const Icon(Icons.bolt),
          ),
          TextButton(
            onPressed:
                !_isRecording && _durations.length > 0 ? _playRecording : null,
            child: const Icon(Icons.play_arrow),
          ),
          TextButton(
            onPressed: _isRecording ? _stopRecording : null,
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
