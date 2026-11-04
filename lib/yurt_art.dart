import 'dart:math' as math;

import 'package:flutter/material.dart';

const yurtRed = Color(0xffd9473a);
const yurtIndigo = Color(0xff34345d);
const yurtGold = Color(0xffe7b95b);

/// Hand-drawn felt applique pattern inspired by shyrdak geometry.
class SteppePatternPainter extends CustomPainter {
  const SteppePatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()..color = yurtRed.withValues(alpha: .11)..style = PaintingStyle.stroke..strokeWidth = 1.25;
    final gold = Paint()..color = yurtGold.withValues(alpha: .22)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    for (var row = 0, y = 24.0; y < size.height + 44; row++, y += 112) {
      for (var col = 0, x = (row.isEven ? 18.0 : 74.0); x < size.width + 44; col++, x += 112) {
        final center = Offset(x, y);
        final path = Path()
          ..moveTo(x, y - 20)..lineTo(x + 8, y - 8)..lineTo(x + 20, y)
          ..lineTo(x + 8, y + 8)..lineTo(x, y + 20)..lineTo(x - 8, y + 8)
          ..lineTo(x - 20, y)..lineTo(x - 8, y - 8)..close();
        canvas.drawPath(path, (row + col).isEven ? ink : gold);
        canvas.drawCircle(center, 4, ink);
        final curl = Path()
          ..moveTo(x + 21, y)..cubicTo(x + 37, y - 16, x + 42, y + 15, x + 27, y + 17)
          ..cubicTo(x + 19, y + 18, x + 18, y + 9, x + 24, y + 8);
        canvas.drawPath(curl, (row + col).isEven ? gold : ink);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SteppePatternPainter oldDelegate) => false;
}

/// Original yurt insignia: tunduk crown, felt roof, and woven banding.
class YurtEmblem extends StatelessWidget {
  const YurtEmblem({super.key, this.size = 128});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _YurtEmblemPainter()),
      );
}

class _YurtEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 128;
    canvas.save();
    canvas.scale(scale, scale);
    canvas.drawCircle(const Offset(64, 64), 61, Paint()..color = const Color(0xff79bfd6));
    canvas.drawCircle(const Offset(64, 64), 55, Paint()..color = const Color(0xffbfe6f5));
    final felt = Paint()..color = const Color(0xfffff8e9);
    final shade = Paint()..color = const Color(0xffeadbbd);
    final red = Paint()..color = yurtRed;
    final dark = Paint()..color = yurtIndigo;
    final roof = Path()
      ..moveTo(23, 57)..quadraticBezierTo(64, 18, 105, 57)
      ..lineTo(100, 65)..lineTo(28, 65)..close();
    canvas.drawPath(roof, felt);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(26, 59, 76, 43), const Radius.circular(8)), felt);
    canvas.drawRect(const Rect.fromLTWH(30, 82, 68, 17), shade);
    canvas.drawRect(const Rect.fromLTWH(27, 76, 74, 8), red);
    canvas.drawRect(const Rect.fromLTWH(27, 72, 74, 3), dark);
    canvas.drawRect(const Rect.fromLTWH(27, 86, 74, 3), dark);
    for (var i = 0; i < 7; i++) {
      final x = 33.0 + i * 10;
      final diamond = Path()..moveTo(x, 77)..lineTo(x + 4, 80)..lineTo(x, 83)..lineTo(x - 4, 80)..close();
      canvas.drawPath(diamond, Paint()..color = const Color(0xffffe8ad));
      canvas.drawLine(Offset(x, 63), Offset(x, 71), Paint()..color = yurtRed..strokeWidth = 1.5);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(56, 83, 16, 19), const Radius.circular(7)), dark);
    canvas.drawCircle(const Offset(64, 43), 13, Paint()..color = yurtGold);
    canvas.drawCircle(const Offset(64, 43), 8, dark);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(Offset(64 + math.cos(angle) * 4, 43 + math.sin(angle) * 4), Offset(64 + math.cos(angle) * 10, 43 + math.sin(angle) * 10), Paint()..color = const Color(0xffffe8ad)..strokeWidth = 2);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _YurtEmblemPainter oldDelegate) => false;
}
