import 'package:shared_preferences/shared_preferences.dart';
import '../models/pattern_type.dart';
import '../models/color_mode.dart';

class SettingsService {
  static const String _keyPatternType = 'pattern_type';
  static const String _keyColorMode = 'color_mode';
  static const String _keySpeed = 'speed';

  static Future<void> saveSettings({
    required PatternType patternType,
    required ColorMode colorMode,
    required double speed,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPatternType, patternType.name);
    await prefs.setString(_keyColorMode, colorMode.name);
    await prefs.setDouble(_keySpeed, speed);
  }

  static Future<({PatternType patternType, ColorMode colorMode, double speed})>
      loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final patternTypeName = prefs.getString(_keyPatternType);
    final colorModeName = prefs.getString(_keyColorMode);
    final speed = prefs.getDouble(_keySpeed) ?? 1.0;

    PatternType patternType;
    ColorMode colorMode;

    try {
      patternType = patternTypeName != null
          ? PatternType.values.byName(patternTypeName)
          : PatternType.spiral;
    } catch (e) {
      patternType = PatternType.spiral;
    }

    try {
      colorMode = colorModeName != null
          ? ColorMode.values.byName(colorModeName)
          : ColorMode.bw;
    } catch (e) {
      colorMode = ColorMode.bw;
    }

    return (patternType: patternType, colorMode: colorMode, speed: speed);
  }

  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPatternType);
    await prefs.remove(_keyColorMode);
    await prefs.remove(_keySpeed);
  }
}
