import 'dart:math';
import 'package:flutter/material.dart';
import '../models/color_mode.dart';

/// 螺旋图案绘制器（阿基米德螺旋）
class SpiralPainter extends CustomPainter {
  final double angle;
  final ColorMode colorMode;

  SpiralPainter({required this.angle, required this.colorMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;
    const spirals = 8;
    const lineWidth = 20.0;

    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _getBackgroundColor(),
    );

    for (int i = 0; i < spirals; i++) {
      final path = Path();
      final offset = (2 * pi / spirals) * i + angle;

      for (double r = 0; r < maxRadius; r += 0.5) {
        final spiralAngle = offset + r * 0.05;
        final x = center.dx + cos(spiralAngle) * r;
        final y = center.dy + sin(spiralAngle) * r;

        if (r == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = _getColor(i, angle)
          ..style = PaintingStyle.stroke
          ..strokeWidth = lineWidth,
      );
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

  Color _getColor(int index, double angle) {
    switch (colorMode) {
      case ColorMode.bw:
        return index % 2 == 0 ? Colors.white : Colors.black;
      case ColorMode.rainbow:
        final hue = (index * 60) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.8, 0.6).toColor();
      case ColorMode.neon:
        final hue = (index * 45 + angle * 50) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 1.0, 0.5).toColor();
      case ColorMode.pinkHeart:
        return const Color(0xFFFF1493).withOpacity(0.6);  // 深粉色，透明度0.6
    }
  }

  @override
  bool shouldRepaint(covariant SpiralPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.colorMode != colorMode;
  }
}
