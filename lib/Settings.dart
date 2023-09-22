import 'package:flutter/material.dart';

class FlasherSettings {
  List<Duration> patterns;

  bool vibrate;

  Color offColor;

  Color onColor;

  FlasherSettings({
    this.patterns = const <Duration>[],
    this.vibrate = false,
    this.offColor = Colors.black,
    this.onColor = Colors.white,
  });
}

typedef SettingsChangedCallback = void Function(FlasherSettings);

class SettingsWidget extends StatefulWidget {
  final SettingsChangedCallback onSettingsChanged;

  SettingsWidget({required this.onSettingsChanged});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  FlasherSettings currentSettings = FlasherSettings();

  // Update the settings and notify the parent when settings are updated
  void updateSettings(FlasherSettings newSettings) {
    setState(() {
      currentSettings = newSettings;
    });

    // Call the callback to pass the updated settings back to parent
    widget.onSettingsChanged(currentSettings);
    print('Settings updated: ${currentSettings.vibrate}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Settings Widget'),
            Switch(
              value: currentSettings.vibrate,
              onChanged: (newValue) {
                FlasherSettings newSettings = FlasherSettings(
                  patterns: currentSettings.patterns,
                  vibrate: newValue,
                  offColor: currentSettings.offColor,
                  onColor: currentSettings.onColor,
                );
                updateSettings(newSettings);
              },
            ),

          ],
        ),
      ),
    );
  }
}
