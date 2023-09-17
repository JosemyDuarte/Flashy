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
  //field to record the timestamp of each press.
  List<DateTime> _presses = [];
  List<Duration> _durations = [];
  bool recording = false;
  String centerText = 'Tap to start recording';

  void _recordPress() {
    setState(() {
      recording = true;
      centerText = 'Recording...';

      // Record the current timestamp.
      _presses.add(DateTime.timestamp());

      // Calculate the durations between each press.
      _durations = [];
      for (int i = 1; i < _presses.length; i++) {
        _durations.add(_presses[i].difference(_presses[i - 1]));
      }
    });
  }

  // clean up the presses and durations
  void _clearPresses() {
    setState(() {
      recording = false;
      centerText = 'Tap to start recording';
      _presses = [];
      _durations = [];
    });
  }

  // stop recording
  void _stopRecording() {
    setState(() {
      recording = false;
      if (_presses.length > 0) {
        centerText = 'Hit play to start flashing';
      } else
        centerText = 'Tap to start recording';
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
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
                'Taps: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${_presses.length}'),
            ],
          )
        ],
      ),
      persistentFooterButtons: <Widget>[
        TextButton(
          onPressed: _clearPresses,
          child: const Icon(Icons.bolt),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatternBackgroundWidget(pattern: _durations),
              ),
            );
          },
          child: const Icon(Icons.play_arrow),
        ),
        TextButton(
          onPressed: _stopRecording,
          child: const Icon(Icons.stop),
        ),
      ],
    );
  }
}
