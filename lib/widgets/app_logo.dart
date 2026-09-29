import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo/mascote do MercaMática (a abelha do rascunho enviado), desenhado
/// apenas com formas do Flutter para não depender de arquivos de imagem
/// externos nesta primeira etapa.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Asas
          Positioned(
            left: size * 0.02,
            child: _wing(size),
          ),
          Positioned(
            right: size * 0.02,
            child: Transform.flip(flipX: true, child: _wing(size)),
          ),
          // Corpo
          Container(
            width: size * 0.62,
            height: size * 0.72,
            decoration: BoxDecoration(
              color: AppColors.reward,
              borderRadius: BorderRadius.circular(size),
              border: Border.all(color: AppColors.textPrimary, width: size * 0.02),
            ),
            child: Center(
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          // Antenas
          Positioned(
            top: 0,
            child: SizedBox(
              width: size * 0.5,
              height: size * 0.22,
              child: CustomPaint(
                painter: _AntennaPainter(color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wing(double size) {
    return Container(
      width: size * 0.34,
      height: size * 0.5,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: AppColors.accent, width: 1.5),
      ),
    );
  }
}

class _AntennaPainter extends CustomPainter {
  final Color color;

  _AntennaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = color;

    final leftStart = Offset(size.width * 0.4, size.height);
    final leftEnd = Offset(size.width * 0.28, size.height * 0.15);
    final rightStart = Offset(size.width * 0.6, size.height);
    final rightEnd = Offset(size.width * 0.72, size.height * 0.15);

    canvas.drawLine(leftStart, leftEnd, paint);
    canvas.drawLine(rightStart, rightEnd, paint);
    canvas.drawCircle(leftEnd, 3.5, dotPaint);
    canvas.drawCircle(rightEnd, 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _AntennaPainter oldDelegate) => false;
}
