import 'package:flutter/material.dart';

/// Paleta e estilo visual do MercaMática.
///
/// A proposta pede uma interface simples, previsível e visual, com poucas
/// opções de tela, textos objetivos, botões grandes e feedback claro
/// (considerando o uso no contexto de autismo e educação financeira).
/// Por isso o tema evita gradientes/efeitos chamativos e prioriza contraste
/// e áreas de toque grandes.
class AppColors {
  AppColors._();

  static const Color honey = Color(0xFFF6C445);
  static const Color honeyDark = Color(0xFFE28A2D);
  static const Color honeyLight = Color(0xFFFCE9AF);
  static const Color bark = Color(0xFF2F2F2F);
  static const Color background = Color(0xFFF7F3E8);
  static const Color success = Color(0xFF6DBB52);
  static const Color error = Color(0xFFD8614C);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2F2F2F);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color formField = Color(0xFFF3DEB6);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.honey,
        primary: AppColors.honey,
        secondary: AppColors.bark,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      splashColor: AppColors.honeyLight.withValues(alpha: 0.35),
      highlightColor: AppColors.honeyLight.withValues(alpha: 0.25),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.honey,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: AppColors.honeyDark, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.formField,
        contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.honeyDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
