# Quiz Motion — Flutter

Implementação da tela inicial do protótipo Quiz Motion, com layout responsivo e componentes reutilizáveis.

## Estrutura

```text
lib/
├── app.dart
├── main.dart
├── core/
│   └── theme/app_theme.dart
└── features/
    └── home/
        ├── data/quiz_topics.dart
        ├── domain/quiz_topic.dart
        └── presentation/
            ├── pages/home_page.dart
            └── widgets/
                ├── challenge_card.dart
                ├── home_bottom_nav.dart
                ├── home_header.dart
                ├── score_summary.dart
                ├── streak_badge.dart
                └── topic_tile.dart
assets/
├── images/hero_quiz.png
└── prototypes/   # referências de todas as telas, tema claro e escuro
```

## Executar

1. Abra a pasta `question` no VS Code ou Android Studio.
2. Execute `flutter pub get`.
3. Execute `flutter run`.

A interface usa componentes Flutter/Material e não adiciona dependências de terceiros. A seleção de tema e quantidade de perguntas já atualiza o estado visual. O botão Jogar está preparado como ponto de integração com o fluxo de perguntas do aplicativo.
