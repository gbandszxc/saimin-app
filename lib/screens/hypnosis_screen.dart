import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pattern_type.dart';
import '../models/color_mode.dart';
import '../painters/spiral_painter.dart';
import '../painters/circles_painter.dart';
import '../painters/vortex_painter.dart';
import '../painters/heart_painter.dart';
import '../widgets/control_panel.dart';
import '../services/settings_service.dart';

/// 催眠图案主屏幕
class HypnosisScreen extends StatefulWidget {
  const HypnosisScreen({super.key});

  @override
  State<HypnosisScreen> createState() => _HypnosisScreenState();
}

class _HypnosisScreenState extends State<HypnosisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _targetFps;

  bool _isPlaying = true;
  double _speed = 1.0;
  PatternType _patternType = PatternType.spiral;
  ColorMode _colorMode = ColorMode.bw;

  bool _showControls = false;
  Timer? _hideTimer;

  double get _rotationAngle => _controller.value * 2 * math.pi;

  @override
  void initState() {
    super.initState();

    _detectRefreshRate();
    _initAnimationController();
    _loadSettings();

    _resetHideTimer();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    if (mounted) {
      setState(() {
        _patternType = settings.patternType;
        _colorMode = settings.colorMode;
        _speed = settings.speed;
      });
    }
  }

  void _detectRefreshRate() {
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final display = platformDispatcher.displays.first;
    final refreshRate = display.refreshRate;

    if (refreshRate >= 90) {
      _targetFps = refreshRate.toInt();
    } else {
      _targetFps = 60;
    }

    debugPrint('检测到刷新率: $refreshRate Hz, 目标帧率: $_targetFps fps');
  }

  void _initAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        if (_isPlaying) {
          setState(() {});
        }
      })..repeat();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _handleLongPress() {
    setState(() {
      _showControls = true;
    });
    _resetHideTimer();
  }

  void _handleTap() {
    if (_showControls) {
      setState(() {
        _showControls = false;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _resetHideTimer();
  }

  void _reset() {
    setState(() {
      _isPlaying = true;
      _speed = 1.0;
      _patternType = PatternType.spiral;
      _colorMode = ColorMode.bw;
    });
    SettingsService.resetSettings();
    _resetHideTimer();
  }

  void _handleSpeedChanged(double value) {
    setState(() {
      _speed = value;
    });
    _saveSettings();
    _resetHideTimer();
  }

  void _handlePatternChanged(PatternType value) {
    setState(() {
      _patternType = value;
    });
    _saveSettings();
    _resetHideTimer();
  }

  void _handleColorModeChanged(ColorMode value) {
    setState(() {
      _colorMode = value;
    });
    _saveSettings();
    _resetHideTimer();
  }

  Future<void> _saveSettings() async {
    await SettingsService.saveSettings(
      patternType: _patternType,
      colorMode: _colorMode,
      speed: _speed,
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupSystemChrome();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onLongPress: _handleLongPress,
        onTap: _handleTap,
        child: Stack(
          children: [
            _buildPatternDisplay(),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  void _setupSystemChrome() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Widget _buildPatternDisplay() {
    return CustomPaint(
      painter: _getPainter(),
      size: Size.infinite,
    );
  }

  CustomPainter _getPainter() {
    switch (_patternType) {
      case PatternType.spiral:
        return SpiralPainter(angle: _rotationAngle * _speed, colorMode: _colorMode);
      case PatternType.circles:
        return CirclesPainter(angle: _rotationAngle * _speed, colorMode: _colorMode);
      case PatternType.vortex:
        return VortexPainter(angle: _rotationAngle * _speed, colorMode: _colorMode);
      case PatternType.heart:
        // 心形模式使用独立动画循环
        return HeartPainter(
          animationValue: _isPlaying ? _rotationAngle * _speed : 0,
          colorMode: _colorMode,
        );
    }
  }

  Widget _buildControlPanel() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      bottom: _showControls ? 0 : -500,
      left: 0,
      right: 0,
      child: _buildPanelWithBackdrop(),
    );
  }

  Widget _buildPanelWithBackdrop() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.85),
              ],
            ),
          ),
          child: ControlPanel(
            isPlaying: _isPlaying,
            speed: _speed,
            patternType: _patternType,
            colorMode: _colorMode,
            onPlayPause: _togglePlayPause,
            onReset: _reset,
            onSpeedChanged: _handleSpeedChanged,
            onPatternChanged: _handlePatternChanged,
            onColorModeChanged: _handleColorModeChanged,
          ),
        ),
      ),
    );
  }
}
