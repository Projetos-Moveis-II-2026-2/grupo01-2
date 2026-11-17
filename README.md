# MercaMática — Mercadinho Matemático (Etapa 1)

Protótipo navegável em Flutter do aplicativo **Mercadinho Matemático**, com
dados 100% mockados, cobrindo a navegação entre as telas
principais.

## O que está nesta entrega (Etapa 1)

Para viabilizar a navegação completa
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
- Feedback de resposta com mensagens de orientação.


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
3. Na pasta do projeto, gere as pastas de plataforma:
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
  main.dart                 
  theme/app_theme.dart       
  models/                     
  data/mock_data.dart         
  widgets/                    
  screens/
    splash_screen.dart
    welcome_screen.dart
    login_screen.dart
    signup_screen.dart
    home_shell.dart           
    math/                     # Matemática Básica (Adição/Subtração)
    choices/                  # Escolha Certa
    profile/                  # Perfil (placeholder)
```

Sem dependências externas além do próprio Flutter SDK (`cupertino_icons`
apenas), para minimizar o risco de conflito de versões no seu ambiente.
