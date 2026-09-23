# MercaMática — Mercadinho Matemático (Etapa 1)

Protótipo navegável em Flutter do aplicativo **Mercadinho Matemático**, com
dados 100% mockados (sem backend), cobrindo a navegação entre as telas
principais.

## O que está nesta entrega (Etapa 1)

Conforme a tabela de entregas da proposta (seção 6), a Etapa 1 cobre
**Adição, Subtração e Escolha Certa**. Para viabilizar a navegação completa
do app desde já, também foram incluídas as telas de abertura/login/cadastro
e um placeholder de Perfil:

- **Abertura (Splash)** → logo + nome do app, navega automaticamente.
- **Boas-vindas** → logo, slogan, botões "Criar uma conta" e "Entrar".
- **Login / Cadastro** → formulários simples e **mockados** (não há
  autenticação real: qualquer preenchimento válido leva à tela principal).
- **Home (navegação por abas)** → Matemática Básica, Escolha Certa e
  Perfil, com os ícones do wireframe.
- **Matemática Básica** → escolha entre Adição/Subtração, com 4 perguntas
  mockadas cada, em formato de múltipla escolha, contextualizadas em
  situações de compra (valor total, troco, desconto).
- **Escolha Certa** → 3 situações mockadas de educação financeira, cada
  uma com alternativas de escolha.
- **Perfil** → tela placeholder com dados mockados, apenas para permitir a
  navegação até essa aba.

### O que ainda não está incluído (propositalmente)

Para respeitar o cronograma de entregas da proposta (seção 6), os itens
abaixo **não** fazem parte desta etapa e aparecem como pontos de extensão
no código (comentários `// Etapa 2/3/4`):

- Feedback de resposta com mensagens de orientação (Etapa 2).
- Consequência da escolha detalhada, sistema de reforço (pontos,
  estrelas, medalhas) e pontuação/progresso (Etapa 3).
- Perfil completo com progresso e histórico (Etapa 4).


## Como rodar

Este ambiente de nuvem não tem acesso ao `storage.googleapis.com`, domínio
usado pelo Flutter para baixar o Dart SDK/engine — por isso não foi
possível rodar `flutter pub get` / `flutter analyze` / `flutter run` aqui
para validar a build automaticamente. O código foi revisado
manualmente (imports, classes, balanceamento de chaves/parênteses), mas
peço que você rode `flutter analyze` localmente antes de considerar
fechada a etapa — qualquer erro que aparecer, me mande a mensagem que eu
ajusto rapidamente.

Passo a passo:

1. Tenha o Flutter instalado (`flutter doctor` sem erros bloqueantes).
2. Descompacte este projeto.
3. Na pasta do projeto, gere as pastas de plataforma (não incluídas aqui
   para evitar conflito de versão com o seu Flutter/Gradle instalado):
   ```
   flutter create --platforms=android,ios,web .
   ```
   Isso **não** sobrescreve o `lib/` nem o `pubspec.yaml` já existentes.
4. Instale as dependências:
   ```
   flutter pub get
   ```
5. Rode o app (mais rápido para testar: Chrome/web):
   ```
   flutter run -d chrome
   ```
   ou em um emulador/dispositivo Android/iOS:
   ```
   flutter run
   ```

## Estrutura do projeto

```
lib/
  main.dart                 # App raiz (MaterialApp)
  theme/app_theme.dart       # Cores e estilos (tema honey/mel)
  models/                     # MathQuestion, ChoiceScenario, UserProfile
  data/mock_data.dart         # Todos os dados mockados da Etapa 1
  widgets/                    # AppLogo (mascote), botões reutilizáveis
  screens/
    splash_screen.dart
    welcome_screen.dart
    login_screen.dart
    signup_screen.dart
    home_shell.dart           # Bottom navigation (3 abas)
    math/                     # Matemática Básica (Adição/Subtração)
    choices/                  # Escolha Certa
    profile/                  # Perfil (placeholder)
```

Sem dependências externas além do próprio Flutter SDK (`cupertino_icons`
apenas), para minimizar o risco de conflito de versões no seu ambiente.
