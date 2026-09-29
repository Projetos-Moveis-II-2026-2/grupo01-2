import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estrutura visual compartilhada pelas telas de login e cadastro.
///
/// O conteúdo fica sobre um fundo creme com nuvens discretas. Cada tela pode
/// escolher se exibe a ilustração do mercadinho e em que ponto o painel branco
/// começa, sem alterar sua lógica de formulário ou navegação.
class AuthPageLayout extends StatelessWidget {
  final Widget child;
  final bool showIllustration;
  final bool signupPanel;

  const AuthPageLayout({
    super.key,
    required this.child,
    this.showIllustration = false,
    this.signupPanel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final panelWidth = screenWidth * 0.93;
          final panelLeft = signupPanel ? screenWidth * 0.07 : 0.0;
          final panelRadius = math.min(132.0, screenWidth * 0.22);

          return Stack(
            children: [
              const Positioned.fill(child: _AuthClouds()),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        if (showIllustration) ...[
                          SizedBox(height: screenWidth * 0.21),
                          Image.asset(
                            'assets/images/mercadinho_ilustracao_paleta.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            // O asset real pode ser substituído aqui sem
                            // alterar a estrutura da tela.
                            errorBuilder: (_, __, ___) => const _AuthImagePlaceholder(),
                          ),
                          SizedBox(height: screenWidth * 0.06),
                        ] else
                          SizedBox(height: screenWidth * 0.25),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: panelWidth,
                            margin: EdgeInsets.only(left: panelLeft),
                            padding: const EdgeInsets.fromLTRB(24, 58, 24, 116),
                            constraints: BoxConstraints(
                              minHeight: math.max(560, constraints.maxHeight * 0.74),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(panelRadius),
                                topRight: Radius.circular(panelRadius),
                              ),
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: math.min(560, panelWidth - 72),
                                ),
                                child: child,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AuthImagePlaceholder extends StatelessWidget {
  const _AuthImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: AppColors.secondaryLight,
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_rounded,
        size: 72,
        color: AppColors.secondary,
      ),
    );
  }
}

class _AuthClouds extends StatelessWidget {
  const _AuthClouds();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CloudPainter());
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryLight.withValues(alpha: 0.5);
    final width = size.width;

    _drawCloud(
      canvas,
      paint,
      x: -width * 0.015,
      y: 18,
      cloudWidth: math.min(270, width * 0.31),
      cloudHeight: 118,
    );
    _drawCloud(
      canvas,
      paint,
      x: width * 0.70,
      y: 0,
      cloudWidth: math.min(280, width * 0.31),
      cloudHeight: 120,
    );
    _drawCloud(
      canvas,
      paint,
      x: -width * 0.05,
      y: math.min(480, size.height * 0.36),
      cloudWidth: math.min(165, width * 0.22),
      cloudHeight: 78,
    );
    _drawCloud(
      canvas,
      paint,
      x: width * 0.77,
      y: math.min(530, size.height * 0.43),
      cloudWidth: math.min(180, width * 0.22),
      cloudHeight: 82,
    );
  }

  void _drawCloud(
    Canvas canvas,
    Paint paint, {
    required double x,
    required double y,
    required double cloudWidth,
    required double cloudHeight,
  }) {
    final baseHeight = cloudHeight * 0.47;
    final radius = Radius.circular(cloudHeight * 0.24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y + cloudHeight * 0.45, cloudWidth, baseHeight),
        radius,
      ),
      paint,
    );
    canvas.drawCircle(
      Offset(x + cloudWidth * 0.27, y + cloudHeight * 0.43),
      cloudHeight * 0.31,
      paint,
    );
    canvas.drawCircle(
      Offset(x + cloudWidth * 0.52, y + cloudHeight * 0.28),
      cloudHeight * 0.40,
      paint,
    );
    canvas.drawCircle(
      Offset(x + cloudWidth * 0.76, y + cloudHeight * 0.43),
      cloudHeight * 0.30,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => false;
}
