import 'package:flutter/material.dart';
import 'package:metronome/FlashingScreen.dart';
import 'package:metronome/Recorder.dart';
import 'package:metronome/Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flasher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flasher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlasherSettings settings = FlasherSettings();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flasher',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Recorder'),
                  Tab(text: 'Settings'),
                ],
              )),
          body: TabBarView(
            children: [
              RecorderWidget(title: widget.title, settings: settings),
              SettingsWidget(onSettingsChanged: (settings) {
                setState(() {
                  this.settings = settings;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
