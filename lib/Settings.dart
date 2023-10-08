import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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

class SettingsWidget extends StatefulWidget {
  final FlasherModel model;

  SettingsWidget({required this.model});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
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
            Text('Vibrate'),
            Switch(
              value: widget.model.vibrate,
              onChanged: (newValue) {
                updateSettings(FlasherModel(
                  vibrate: newValue,
                  offColor: widget.model.offColor,
                  onColor: widget.model.onColor,
                ));
              },
            ),
            Text('Off Color'),
            MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch? offColor) {
                if (offColor == null) return;
                updateSettings(FlasherModel(
                  vibrate: widget.model.vibrate,
                  offColor: Color.fromRGBO(
                    offColor.red,
                    offColor.green,
                    offColor.blue,
                    offColor.opacity,
                  ),
                  onColor: widget.model.onColor,
                ));
              },
              selectedColor: widget.model.offColor,
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
                updateSettings(FlasherModel(
                  vibrate: widget.model.vibrate,
                  offColor: widget.model.offColor,
                  onColor: Color.fromRGBO(
                    onColor.red,
                    onColor.green,
                    onColor.blue,
                    onColor.opacity,
                  ),
                ));
              },
              selectedColor: widget.model.onColor,
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
