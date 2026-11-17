import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mercadinho_matematico/data/local_user_storage.dart';
import 'package:mercadinho_matematico/main.dart';
import 'package:mercadinho_matematico/providers/user_progress_provider.dart';

void main() {
  testWidgets('MercaMaticaApp smoke test', (WidgetTester tester) async {
    final progressProvider = UserProgressProvider(
      storage: LocalUserStorage(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: progressProvider,
        child: const MercaMaticaApp(),
      ),
    );

    // Verifica que a tela de login/boas-vindas é exibida
    expect(find.text('Login'), findsWidgets);
  });
}
