import 'dart:math';
import 'package:flutter/material.dart';
import '../models/color_mode.dart';

/// 爱心图案绘制器
class HeartPainter extends CustomPainter {
  final double animationValue;
  final ColorMode colorMode;

  HeartPainter({required this.animationValue, required this.colorMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;

    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _getBackgroundColor(),
    );

    // 同心圆扩散动画
    const circleSpacing = 40.0;
    const strokeWidth = 20.0;

    for (double i = 0; i < maxRadius * 1.5; i += circleSpacing) {
      final radius = (i + animationValue * circleSpacing) % (maxRadius * 1.5);
      final opacity = 1.0 - (radius / (maxRadius * 1.5));
      if (opacity <= 0) continue;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = _getPatternColor().withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    // 爱心跳动动画
    final pulseScale = 1.0 + animationValue * 0.15;

    // 爱心大小 (80%)
    final aspectRatio = size.width / size.height;
    final baseSize = size.width * (aspectRatio > 1.5 ? 0.10 : 0.14);
    final heartSize = baseSize * pulseScale;

    // 三层绘制（从外到内）
    // 1. 外描边：深粉色
    _drawHeart(canvas, center, heartSize, _getOuterColor());

    // 2. 内描边/填充：粉色（和同心圆同色）
    _drawHeart(canvas, center, heartSize * 0.85, _getMiddleColor());

    // 3. 中心：白色
    _drawHeart(canvas, center, heartSize * 0.7, Colors.white);
  }

  Color _getBackgroundColor() {
    switch (colorMode) {
      case ColorMode.bw:
      case ColorMode.rainbow:
      case ColorMode.neon:
        return Colors.black;
      case ColorMode.pinkHeart:
        return const Color(0xFFFFF5F5);
    }
  }

  Color _getPatternColor() {
    switch (colorMode) {
      case ColorMode.bw:
        return Colors.white;
      case ColorMode.rainbow:
        return HSLColor.fromAHSL(1.0, 300, 0.8, 0.6).toColor();
      case ColorMode.neon:
        return HSLColor.fromAHSL(1.0, 300, 1.0, 0.5).toColor();
      case ColorMode.pinkHeart:
        return const Color(0xFFFF9AFC);
    }
  }

  Color _getMiddleColor() {
    switch (colorMode) {
      case ColorMode.bw:
        return Colors.white;
      case ColorMode.rainbow:
        return HSLColor.fromAHSL(1.0, 300, 0.8, 0.6).toColor();
      case ColorMode.neon:
        return HSLColor.fromAHSL(1.0, 300, 1.0, 0.5).toColor();
      case ColorMode.pinkHeart:
        return const Color(0xFFFF9AFC);
    }
  }

  Color _getOuterColor() {
    switch (colorMode) {
      case ColorMode.bw:
        return Colors.black;
      case ColorMode.rainbow:
        return HSLColor.fromAHSL(1.0, 280, 0.8, 0.5).toColor(); // 深紫色
      case ColorMode.neon:
        return HSLColor.fromAHSL(1.0, 280, 1.0, 0.7).toColor(); // 亮紫色
      case ColorMode.pinkHeart:
        return const Color(0xFFFF69B4); // HotPink 深粉色
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final path = Path();
    final points = <Offset>[];

    // 使用心形数学公式
    for (double t = 0; t < 2 * pi; t += 0.01) {
      final x = size * pow(sin(t), 3);
      final y = size * (13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)) / 16;
      points.add(Offset(center.dx + x, center.dy - y));
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()..color = color..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.colorMode != colorMode;
  }
}
