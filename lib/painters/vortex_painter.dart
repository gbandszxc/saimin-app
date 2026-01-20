import 'dart:math';
import 'package:flutter/material.dart';
import '../models/color_mode.dart';

/// 漩涡图案绘制器
class VortexPainter extends CustomPainter {
  final double angle;
  final ColorMode colorMode;

  VortexPainter({required this.angle, required this.colorMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;
    const segments = 12;
    const lineWidth = 8.0;

    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _getBackgroundColor(),
    );

    for (int i = 0; i < segments; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + (2 * pi / segments) * i);

      final path = Path();
      path.moveTo(0, 0);

      for (double r = 0; r < maxRadius; r += 5) {
        final curve = sin(r * 0.05 + angle) * 50;
        path.lineTo(r, curve);
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = _getColor(i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = lineWidth,
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
        return index % 2 == 0 ? Colors.white : Colors.black;
      case ColorMode.rainbow:
        final hue = (index * 30) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.8, 0.6).toColor();
      case ColorMode.neon:
        final hue = (index * 30 + angle * 50) % 360;
        return HSLColor.fromAHSL(1.0, hue.toDouble(), 1.0, 0.5).toColor();
      case ColorMode.pinkHeart:
        return const Color(0xFFFF1493).withOpacity(0.6);  // 深粉色，透明度0.6
    }
  }

  @override
  bool shouldRepaint(covariant VortexPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.colorMode != colorMode;
  }
}
