import 'package:flutter/material.dart';
import 'package:metronome/FlashingScreen.dart';
import 'package:metronome/Recorder.dart';
import 'package:metronome/Settings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => FlasherModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pattern Flasher',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        home: MyHomePage(
            title: 'Pattern Flasher',
            analytics: analytics,
            observer: observer));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pattern Flasher',
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
            body: Consumer<FlasherModel>(builder: (context, model, child) {
              return TabBarView(
                children: [
                  RecorderWidget(title: widget.title, model: model),
                  SettingsWidget(model: model),
                ],
              );
            }),
          )),
    );
  }
}
