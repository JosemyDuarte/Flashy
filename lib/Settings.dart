import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class FlasherSettings {
  bool vibrate;

  Color offColor;

  Color onColor;

  FlasherSettings({
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
            Text('Vibrate'),
            Switch(
              value: currentSettings.vibrate,
              onChanged: (newValue) {
                updateSettings(FlasherSettings(
                  vibrate: newValue,
                  offColor: currentSettings.offColor,
                  onColor: currentSettings.onColor,
                ));
              },
            ),
            MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch? offColor) {
                if (offColor == null) return;
                updateSettings(FlasherSettings(
                  vibrate: currentSettings.vibrate,
                  offColor: Color.fromRGBO(
                    offColor.red,
                    offColor.green,
                    offColor.blue,
                    offColor.opacity,
                  ),
                  onColor: currentSettings.onColor,
                ));
              },
              selectedColor: currentSettings.offColor,
              colors: [
                Colors.red,
                Colors.deepOrange,
                Colors.yellow,
                Colors.lightGreen,
                Colors.grey,
              ],
            ),
            MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch? onColor) {
                if (onColor == null) return;
                updateSettings(FlasherSettings(
                  vibrate: currentSettings.vibrate,
                  offColor: currentSettings.offColor,
                  onColor: Color.fromRGBO(
                    onColor.red,
                    onColor.green,
                    onColor.blue,
                    onColor.opacity,
                  ),
                ));
              },
              selectedColor: currentSettings.onColor,
              colors: [
                Colors.red,
                Colors.deepOrange,
                Colors.yellow,
                Colors.lightGreen,
                Colors.grey,
              ],
            )
          ],
        ),
      ),
    );
  }
}
