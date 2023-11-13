import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:vibration/vibration.dart';

class FlasherModel extends ChangeNotifier {
  bool vibrate;

  Color offColor;

  Color onColor;

  List<Duration> _pattern = [];

  FlasherModel({
    this.vibrate = false,
    this.offColor = Colors.black,
    this.onColor = Colors.white,
  });

  void updateSettings({
    bool? vibrate,
    Color? offColor,
    Color? onColor,
  }) {
    this.vibrate = vibrate ?? this.vibrate;
    this.offColor = offColor ?? this.offColor;
    this.onColor = onColor ?? this.onColor;

    notifyListeners();
  }

  void overwritePatterns(List<Duration> newPattern) {
    _pattern = newPattern;

    notifyListeners();
  }

  void addPattern(Duration newPattern) {
    _pattern.add(newPattern);

    notifyListeners();
  }

  List<Duration> get pattern => _pattern;
}

// Make a custom ColorSwatch to name map from the above custom colors.
final Map<ColorSwatch<Object>, String> colorsNameMap =
    <ColorSwatch<Object>, String>{
  ColorTools.createPrimarySwatch(Colors.black): 'Black',
  ColorTools.createPrimarySwatch(Colors.white): 'White',
  ColorTools.createAccentSwatch(Colors.blue): 'Blue',
  ColorTools.createAccentSwatch(Colors.red): 'Red',
  ColorTools.createPrimarySwatch(Colors.yellow): 'Yellow',
  ColorTools.createPrimarySwatch(Colors.green): 'Green',
  ColorTools.createPrimarySwatch(Colors.deepPurple): 'Purple',
};

class SettingsWidget extends StatefulWidget {
  final FlasherModel model;

  SettingsWidget({required this.model});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Settings tab");
  }

  // Update the settings and notify the parent when settings are updated
  void updateSettings(FlasherModel newModel) {
    widget.model.updateSettings(
      vibrate: newModel.vibrate,
      offColor: newModel.offColor,
      onColor: newModel.onColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Vibrate',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Switch(
              value: widget.model.vibrate,
              onChanged: (newValue) {
                if (newValue) {
                  Vibration.vibrate(duration: 250, amplitude: 50);
                }
                updateSettings(FlasherModel(
                  vibrate: newValue,
                  offColor: widget.model.offColor,
                  onColor: widget.model.onColor,
                ));
              },
            ),
            // Show the color picker in sized box in a raised card.
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Card(
                  elevation: 1,
                  child: ColorPicker(
                    // Use the screenPickerColor as start color.
                    color: widget.model.onColor,
                    // Update the screenPickerColor using the callback.
                    onColorChanged: (Color color) {
                      setState(() {
                        widget.model.updateSettings(
                          vibrate: widget.model.vibrate,
                          offColor: widget.model.offColor,
                          onColor: color,
                        );
                      });
                    },
                    width: 44,
                    height: 44,
                    borderRadius: 22,
                    heading: Text(
                      'On Color',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.both: false,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.wheel: false,
                    },
                    subheading: null,
                    enableShadesSelection: false,
                    customColorSwatchesAndNames: colorsNameMap,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Card(
                  elevation: 1,
                  child: ColorPicker(
                    // Use the screenPickerColor as start color.
                    color: widget.model.offColor,
                    // Update the screenPickerColor using the callback.
                    onColorChanged: (Color color) {
                      setState(() {
                        widget.model.updateSettings(
                          vibrate: widget.model.vibrate,
                          offColor: color,
                          onColor: widget.model.onColor,
                        );
                      });
                    },
                    width: 44,
                    height: 44,
                    borderRadius: 22,
                    heading: Text(
                      'Off Color',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.both: false,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.wheel: false,
                    },
                    subheading: null,
                    enableShadesSelection: false,
                    customColorSwatchesAndNames: colorsNameMap,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
