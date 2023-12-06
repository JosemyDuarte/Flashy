import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pattern_flash/recorder.dart';
import 'package:pattern_flash/settings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'flasher_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAnalytics.instance
        .setDefaultEventParameters({"version": '1.0.0'});
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
        debugShowCheckedModeBanner: false,
        title: 'Pattern Flasher',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
          visualDensity: VisualDensity.standard,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreen instead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Home Page");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
      ),
    );
  }
}
