import 'dart:math';
import 'package:flutter/material.dart';
import '../models/color_mode.dart';

/// 同心圆绘制器
class CirclesPainter extends CustomPainter {
  final double angle;
  final ColorMode colorMode;

  CirclesPainter({required this.angle, required this.colorMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;
    const numCircles = 30;

    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _getBackgroundColor(),
    );

    for (int i = 0; i < numCircles; i++) {
      final radius = (maxRadius / numCircles) * i;
      final rotation = angle + i * 0.1;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);

      canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..color = _getColor(i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

      canvas.restore();
    }
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

  Color _getColor(int index) {
    switch (colorMode) {
      case ColorMode.bw:
        return index % 2 == 0 ? Colors.white : const Color(0xFF888888);
      case ColorMode.rainbow:
        final hue = (index * 12) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
      case ColorMode.neon:
        final hue = (index * 12 + angle * 50) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 1.0, 0.5).toColor();
      case ColorMode.pinkHeart:
        return const Color(0xFFFF9AFC).withOpacity(0.8);
    }
  }

  @override
  bool shouldRepaint(covariant CirclesPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.colorMode != colorMode;
  }
}
