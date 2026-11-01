# Quiz Motion

Aplicativo de quiz desenvolvido em Flutter, integrado a uma API REST em Dart (Shelf) e banco MySQL.

## Funcionalidades atuais

- Seleção de tema: **Inglês**, **Gerais** e **Tecnologia**.
- Escolha de quantidade de perguntas por rodada.
- Carregamento das perguntas e alternativas pela API.
- Validação das respostas no backend.
- Resumo da rodada com aproveitamento, acertos, erros, tempo e revisão das respostas.
- Cadastro de perguntas e alternativas.
- Alternância entre tema claro e escuro, com preferência persistida localmente.
- Tela de desafios identificada como **Em desenvolvimento**.

> O aplicativo não exibe sequência de dias, pontuação histórica ou ranking. Esses recursos foram retirados porque não fazem parte do escopo atual nem possuem persistência no banco.

## Estrutura do frontend

```text
frontend/lib/
├── app.dart
├── main.dart
├── core/
│   ├── network/              # comunicação HTTP com o backend
│   └── theme/                # temas claro/escuro e persistência
└── features/
    ├── home/                 # lobby e seleção dos três temas
    ├── create/               # cadastro de perguntas
    ├── quiz/                 # rodada ativa, resumo e revisão
    ├── challenges/           # tela Em desenvolvimento
    ├── settings/             # preferências de aparência
    └── shell/                # navegação principal
```

## Fluxo de uma rodada

1. O usuário escolhe Inglês, Gerais ou Tecnologia e a quantidade de perguntas.
2. O Flutter chama `GET /api/perguntas?tema=<tema>&limite=<quantidade>`.
3. A tela de quiz apresenta uma pergunta por vez e suas alternativas.
4. Ao confirmar, o Flutter chama `POST /api/perguntas/{id}/resposta`.
5. A API verifica a alternativa no MySQL e retorna se está correta.
6. O Flutter contabiliza o resultado da sessão e apresenta o resumo e a revisão.

O resultado da rodada é mantido em memória no aplicativo. Não existe histórico de partidas ou ranking persistido no banco.

## Requisitos

- Flutter SDK compatível com `frontend/pubspec.yaml`.
- Dart SDK.
- MySQL ativo e backend configurado.

## Executar

Terminal 1 — backend:

```bash
cd BACKEND
dart pub get
dart analyze
dart run bin/server.dart
```

Terminal 2 — frontend:

```bash
cd frontend
flutter pub get
flutter analyze
flutter run
```

A API deve estar ativa antes de iniciar uma partida ou cadastrar uma pergunta.

## Endereço da API

A configuração padrão em `lib/core/network/quiz_api_service.dart` utiliza:

- Web e Windows: `http://localhost:8080/api`
- Emulador Android: `http://10.0.2.2:8080/api`

Para um celular físico, configure o IP local do computador e permita a porta 8080 no firewall.

## Temas e banco de dados

A interface apresenta somente Inglês, Gerais e Tecnologia. O backend também valida os temas aceitos no cadastro.

Para bancos já existentes, execute `BACKEND/database/migrate_topics.sql` após fazer backup. O script normaliza nomes conhecidos e lista temas restantes para revisão; ele não apaga dados automaticamente.

## Preferências

O modo claro/escuro é global e salvo com `shared_preferences`. A escolha de idioma da interface não está implementada nesta versão; o conteúdo das perguntas depende do que estiver cadastrado no banco.

## Limitações conhecidas

- Não há autenticação ou perfil de usuário.
- Não há ranking, sequência de dias ou histórico persistente.
- A tela Desafios está em desenvolvimento.
- A revisão mostra a resposta escolhida e se foi correta. A API atual não expõe a alternativa correta na consulta pública, para não revelar respostas antes da confirmação.
