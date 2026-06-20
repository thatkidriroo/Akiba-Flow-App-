import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ScoreGauge extends StatelessWidget {
  final int score;
  final Color gaugeBg;
  final Color textSecondary;
  final Color textMuted;

  const ScoreGauge({
    super.key,
    required this.score,
    required this.gaugeBg,
    required this.textSecondary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final sc = scoreColor(score);
    final pct = ((score - 300) / 550).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 160,
          height: 130,
          child: CustomPaint(
            painter: _GaugePainter(
              score: score,
              scColor: sc['color'] as Color,
              gaugeBg: gaugeBg,
              pct: pct,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sc['label'] as String,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('300 Poor', style: TextStyle(fontSize: 11, color: textMuted)),
              Text('850 Excellent', style: TextStyle(fontSize: 11, color: textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int score;
  final Color scColor;
  final Color gaugeBg;
  final double pct;

  _GaugePainter({
    required this.score,
    required this.scColor,
    required this.gaugeBg,
    required this.pct,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    final radius = 52.0;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    final bgPaint = Paint()
      ..color = gaugeBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = scColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * pct,
      false,
      fgPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: score.toString(),
        style: TextStyle(
          color: scColor,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, 18));
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.pct != pct;
}
