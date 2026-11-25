# MercaMática — Mercadinho Matemático

O MercaMática é um aplicativo educacional desenvolvido em Flutter que
trabalha matemática básica e educação financeira por meio de situações
contextualizadas em um mercadinho.

O projeto usa dados locais mockados e salva o progresso no próprio
dispositivo, sem necessidade de banco de dados externo.

## Principais funcionalidades

### Matemática Básica

- Prática de **Adição** e **Subtração**.
- Três níveis de dificuldade: Fácil, Médio e Difícil.
- Perguntas contextualizadas com compras, troco, desconto e orçamento.
- Feedback imediato após cada resposta.
- Ao errar, o aplicativo apresenta uma dica e permite nova tentativa.
- Acertos sem dica valem 10 pontos e acertos com dica valem 5 pontos.
- Cada acerto em Matemática concede uma ficha ao concluir a atividade.

### Mercadinho

- 16 situações práticas de educação financeira.
- Situações classificadas nos níveis Fácil, Médio e Difícil.
- Temas como identificação de cédulas e moedas, troco, economia,
  comparação de preços, cofrinho, listas de compras e planejamento.
- Situações objetivas apresentam dica visual após uma resposta incorreta.
- Situações abertas usam uma reflexão educativa em vez de “erro”.
- Uma ficha desbloqueia uma situação; depois do desbloqueio, ela fica
  disponível gratuitamente.
- Cenários concluídos anteriormente permanecem desbloqueados.

### Fichas e progresso

- As fichas são obtidas em atividades de Matemática.
- Cada situação do Mercadinho custa uma ficha para desbloquear.
- Pontos, fichas e histórico são calculados pelo
  `UserProgressProvider`.
- O saldo e o progresso são persistidos localmente.
- O sistema impede que uma mesma conclusão seja recompensada duas vezes.
- Compras de desbloqueio são concluídas somente após o salvamento local
  funcionar, evitando cobrança parcial.

### Perfil

- Avatar personalizável com persistência local.
- Nome do usuário local.
- Pontuação acumulada e número de atividades concluídas.
- Progresso geral e barras separadas para Matemática e Mercadinho.
- Estatísticas de acertos sem dica, acertos com dica e erros.
- Histórico das cinco atividades mais recentes.
- Ícones diferentes para distinguir Matemática e Mercadinho no histórico.
- Avisos visíveis quando o carregamento ou salvamento local falhar.

## Melhorias recentes

- Os textos sobre fichas agora explicam como utilizá-las no Mercadinho.
- O perfil possui progresso separado por módulo.
- Situações concluídas aparecem como “Concluída”.
- O histórico usa ícones específicos para cada módulo.
- O resumo de Matemática usa uma animação ao apresentar o ganho de fichas.
- Ao praticar novamente, perguntas e alternativas são embaralhadas.
- A grade de respostas se adapta a telas menores e mais largas.
- Avatares, opções e indicadores receberam melhor semântica para
  leitores de tela.
- O botão usado sem fichas leva diretamente ao conteúdo de prática.

## Estrutura das telas

- **Boas-vindas**: entrada simples no aplicativo.
- **Matemática Básica**: escolha de operação e nível.
- **Mercadinho**: escolha de nível e situação.
- **Perfil**: avatar, progresso, saldo e histórico.
- **Navegação principal**: barra inferior com Matemática, Mercadinho e
  Perfil.

O login e o cadastro das versões iniciais continuam no projeto, mas o
perfil atual é local e único, sem autenticação externa.


## Como rodar

Passo a passo:

1. Tenha o Flutter instalado (`flutter doctor` sem erros bloqueantes).
2. Abra o projeto no terminal.
3. Instale as dependências:
   ```powershell
   flutter pub get
   ```
4. Execute no Chrome:
   ```powershell
   flutter run -d chrome
   ```
5. Ou execute em Android/iOS/Windows, conforme o dispositivo disponível:
   ```powershell
   flutter run
   ```

Antes de executar em uma plataforma ainda não configurada, gere os
arquivos necessários:

```powershell
flutter create --platforms=android,ios,windows,chrome .
flutter pub get
```

## Validação

Para verificar o código e executar todos os testes:

```powershell
flutter analyze
flutter test
```

## Estrutura do projeto

```
lib/
  main.dart
  theme/app_theme.dart
  models/
  data/
    mock_data.dart
    local_user_storage.dart
  providers/
    user_progress_provider.dart
  widgets/
  screens/
    splash_screen.dart
    welcome_screen.dart
    login_screen.dart
    signup_screen.dart
    home_shell.dart
    math/             # Adição e Subtração
    choices/          # Situações de educação financeira
    profile/          # Perfil, progresso e histórico
test/
  choice_access_widget_test.dart
  choice_unlock_test.dart
  token_balance_test.dart
  widget_test.dart
```
