# Quiz Motion

Aplicativo de quiz desenvolvido em Flutter, com API REST em Dart (Shelf) e persistência em MySQL.

## Visão geral

O repositório contém duas aplicações:

- `frontend/`: aplicativo Flutter (Android, Windows e Web).
- `BACKEND/`: API REST Dart + Shelf, com MySQL.

## Executar o projeto

### 1. Banco e API

Consulte [`BACKEND/README.md`](BACKEND/README.md). Em resumo:

1. Inicie o MySQL.
2. Execute `BACKEND/database/schema.sql` caso o banco ainda não exista.
3. Copie `BACKEND/.env.example` para `BACKEND/.env` e configure as credenciais.
4. No terminal, entre em `BACKEND` e execute:

```bash
dart pub get
dart analyze
dart run bin/server.dart
```

A API fica em `http://localhost:8080`.

### 2. Aplicativo Flutter

Em outro terminal, entre em `frontend` e execute:

```bash
flutter pub get
flutter analyze
flutter run
```

O endereço padrão da API é `localhost:8080` para Web/Windows e `10.0.2.2:8080` para emulador Android. Para celular físico, configure o IP local do computador no cliente HTTP e permita a porta 8080 no firewall.

## Organização do frontend

```text
lib/
├── app.dart
├── main.dart
├── core/
│   ├── network/quiz_api_service.dart
│   └── theme/
│       ├── app_theme.dart
│       └── theme_controller.dart
└── features/
    ├── challenges/presentation/pages/
    ├── create/presentation/pages/
    ├── home/
    ├── quiz/presentation/pages/
    ├── settings/presentation/pages/
    └── shell/presentation/pages/
```

## Fluxo de uma partida

1. A Home carrega os temas cadastrados na API (`GET /api/temas`).
2. O usuário escolhe tema e quantidade de perguntas.
3. O aplicativo solicita as perguntas (`GET /api/perguntas?tema=...&limite=...`).
4. A tela de quiz exibe uma pergunta por vez e permite selecionar uma alternativa.
5. Ao confirmar, o Flutter envia o ID da alternativa para `POST /api/perguntas/{id}/resposta`.
6. A API verifica a resposta no MySQL e devolve `{ "correta": true|false }`.
7. Ao final, o resumo apresenta acertos, erros, percentual e duração da sessão.

## Cadastro de perguntas

Na aba **Criar**, o usuário informa enunciado, tema e alternativas, marca exatamente uma alternativa correta e envia `POST /api/perguntas`. A API valida os dados e grava pergunta e alternativas em uma transação.

## Tema claro e escuro

A aba **Ajustes** permite alternar o tema. A preferência é persistida localmente com `shared_preferences` e carregada antes de iniciar a aplicação.

## Limites atuais

O banco atual guarda temas, perguntas e alternativas. Não existem entidades de usuário, autenticação, histórico persistente, ranking ou sincronização de preferências. O resumo de cada partida é calculado localmente ao terminar a sessão; não é salvo no servidor. A aba Desafios informa esse limite sem simular dados inexistentes.
