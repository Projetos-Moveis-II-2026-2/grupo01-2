import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mercadinho_matematico/main.dart';
import 'package:mercadinho_matematico/providers/user_progress_provider.dart';
import 'support/memory_user_storage.dart';

void main() {
  testWidgets('MercaMaticaApp smoke test', (WidgetTester tester) async {
    final progressProvider = UserProgressProvider(
      storage: MemoryUserStorage(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: progressProvider,
        child: const MercaMaticaApp(),
      ),
    );

    // O fluxo atual abre diretamente a tela de boas-vindas.
    expect(find.text('Começar a praticar'), findsOneWidget);
  });
}
