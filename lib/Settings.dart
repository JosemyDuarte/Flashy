import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class FlasherSettings extends ChangeNotifier {
  bool vibrate;

  Color offColor;

  Color onColor;

  FlasherSettings({
    this.vibrate = false,
    this.offColor = Colors.black,
    this.onColor = Colors.white,
  });

  void overwrite({
    bool? vibrate,
    Color? offColor,
    Color? onColor,
  }) {
    this.vibrate = vibrate ?? this.vibrate;
    this.offColor = offColor ?? this.offColor;
    this.onColor = onColor ?? this.onColor;

    notifyListeners();
  }
}

class SettingsWidget extends StatefulWidget {
  final FlasherSettings settings;

  SettingsWidget({required this.settings});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  // Update the settings and notify the parent when settings are updated
  void updateSettings(FlasherSettings newSettings) {
    print('-' * 20);
    print('oldVibrate: ${widget.settings.vibrate}');
    print('oldOffColor: ${widget.settings.offColor}');
    print('oldOnColor: ${widget.settings.onColor}');
    print('-' * 20);
    print('newVibrate: ${newSettings.vibrate}');
    print('newOffColor: ${newSettings.offColor}');
    print('newOnColor: ${newSettings.onColor}');
    print('-' * 20);

    widget.settings.overwrite(
      vibrate: newSettings.vibrate,
      offColor: newSettings.offColor,
      onColor: newSettings.onColor,
    );
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
              value: widget.settings.vibrate,
              onChanged: (newValue) {
                updateSettings(FlasherSettings(
                  vibrate: newValue,
                  offColor: widget.settings.offColor,
                  onColor: widget.settings.onColor,
                ));
              },
            ),
            Text('Off Color'),
            MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch? offColor) {
                if (offColor == null) return;
                updateSettings(FlasherSettings(
                  vibrate: widget.settings.vibrate,
                  offColor: Color.fromRGBO(
                    offColor.red,
                    offColor.green,
                    offColor.blue,
                    offColor.opacity,
                  ),
                  onColor: widget.settings.onColor,
                ));
              },
              selectedColor: widget.settings.offColor,
              colors: [
                Colors.red,
                Colors.deepOrange,
                Colors.yellow,
                Colors.lightGreen,
                Colors.grey,
              ],
            ),
            Text('On Color'),
            MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch? onColor) {
                if (onColor == null) return;
                updateSettings(FlasherSettings(
                  vibrate: widget.settings.vibrate,
                  offColor: widget.settings.offColor,
                  onColor: Color.fromRGBO(
                    onColor.red,
                    onColor.green,
                    onColor.blue,
                    onColor.opacity,
                  ),
                ));
              },
              selectedColor: widget.settings.onColor,
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
