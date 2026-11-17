import 'package:flutter/material.dart';

/// Representação de um avatar disponível para o perfil do usuário.
class AppAvatar {
  final String id;
  final String name;
  final String emoji;
  final Color backgroundColor;

  const AppAvatar({
    required this.id,
    required this.name,
    required this.emoji,
    required this.backgroundColor,
  });

  /// Lista com todos os avatares disponíveis no app.
  static const List<AppAvatar> all = [
    AppAvatar(
      id: 'student',
      name: 'Estudante',
      emoji: '🧑‍🎓',
      backgroundColor: Color(0xFFDDEEDB),
    ),
    AppAvatar(
      id: 'boy',
      name: 'Menino',
      emoji: '👦',
      backgroundColor: Color(0xFFDCECF4),
    ),
    AppAvatar(
      id: 'girl',
      name: 'Menina',
      emoji: '👧',
      backgroundColor: Color(0xFFFDE8E8),
    ),
    AppAvatar(
      id: 'fox',
      name: 'Raposinha',
      emoji: '🦊',
      backgroundColor: Color(0xFFFFE8D6),
    ),
    AppAvatar(
      id: 'cat',
      name: 'Gatinho',
      emoji: '🐱',
      backgroundColor: Color(0xFFFFF1C5),
    ),
    AppAvatar(
      id: 'bear',
      name: 'Ursinho',
      emoji: '🐻',
      backgroundColor: Color(0xFFEDE0D4),
    ),
    AppAvatar(
      id: 'robot',
      name: 'Robô',
      emoji: '🤖',
      backgroundColor: Color(0xFFE2EAFC),
    ),
    AppAvatar(
      id: 'lion',
      name: 'Leãozinho',
      emoji: '🦁',
      backgroundColor: Color(0xFFFFE5B4),
    ),
    AppAvatar(
      id: 'apple',
      name: 'Maçãzinha',
      emoji: '🍎',
      backgroundColor: Color(0xFFFFD6D6),
    ),
    AppAvatar(
      id: 'coin',
      name: 'Moedinha',
      emoji: '🪙',
      backgroundColor: Color(0xFFFFF3CD),
    ),
    AppAvatar(
      id: 'cart',
      name: 'Mercadinho',
      emoji: '🛒',
      backgroundColor: Color(0xFFDDEEDB),
    ),
    AppAvatar(
      id: 'rocket',
      name: 'Foguete',
      emoji: '🚀',
      backgroundColor: Color(0xFFD0F4DE),
    ),
  ];

  static AppAvatar byId(String? id) {
    if (id == null) return all.first;
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => all.first,
    );
  }
}
