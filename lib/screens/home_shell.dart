import 'package:flutter/material.dart';

import 'choices/choices_home_screen.dart';
import 'math/math_home_screen.dart';
import 'profile/profile_screen.dart';
import '../theme/app_theme.dart';

/// Estrutura principal de navegação do app, com a barra inferior de 3
/// abas indicada no wireframe: Matemática Básica (ícone +/-), Escolha
/// Certa (ícone de cesta) e Perfil (ícone de pessoa).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});

  static const routeName = '/home';

  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _selectedIndex = widget.initialIndex;

  static const _screens = [
    MathHomeScreen(),
    ChoicesHomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            backgroundColor: Colors.white,
            indicatorColor: AppColors.honeyLight,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calculate_outlined),
                selectedIcon: Icon(Icons.calculate_rounded),
                label: 'Matemática',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_basket_outlined),
                selectedIcon: Icon(Icons.shopping_basket_rounded),
                label: 'Escolha Certa',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
