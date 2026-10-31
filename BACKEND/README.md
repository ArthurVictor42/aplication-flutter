# Quiz Motion — Backend

API REST em Dart com Shelf e MySQL. A arquitetura separa HTTP, regras de negócio e persistência.

## Requisitos e configuração

- Dart SDK compatível com `pubspec.yaml`.
- MySQL Server ativo.
- Banco e tabelas criados com `database/schema.sql`.

Na pasta `BACKEND`, copie `.env.example` para `.env` e configure `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `API_HOST` e `API_PORT`.

```bash
dart pub get
dart analyze
dart run bin/server.dart
```

O servidor padrão inicia em `http://localhost:8080`. Não versione nem compartilhe o `.env`.

## Organização

```text
lib/src/
├── config/                  # conexão MySQL e carregamento do .env
├── http/                    # respostas JSON padronizadas
└── questions/
    ├── controllers/         # recebe HTTP e converte em resposta
    ├── dtos/                # estrutura e validação do JSON de entrada
    ├── models/              # pergunta e alternativa
    ├── repositories/        # consultas e transações SQL
    ├── routes/              # registro dos endpoints Shelf
    └── services/
        ├── question_service.dart
        └── question_service_impl.dart
```

## Fluxo interno

`HTTP Request → Route → Controller → DTO → QuestionService → QuestionServiceImpl → QuestionRepository → MySQL`.

- **Routes** associam cada endpoint a um método do controller.
- **Controller** interpreta parâmetros/corpo HTTP e produz respostas JSON.
- **DTO** converte os dados recebidos para estruturas tipadas.
- **QuestionService** define o contrato da funcionalidade.
- **QuestionServiceImpl** aplica regras de negócio, limites e temas permitidos.
- **QuestionRepository** executa SQL e transações.
- **Models** representam e serializam perguntas e alternativas.

A criação de uma pergunta e suas alternativas ocorre em uma transação: se uma inserção falhar, o banco reverte o conjunto.

## Temas permitidos

O domínio aceita somente:

- `Inglês`
- `Gerais`
- `Tecnologia`

A validação ocorre no `QuestionServiceImpl`. O endpoint de temas retorna apenas temas oficiais que tenham perguntas cadastradas. A interface Flutter apresenta sempre as três opções.

Para atualizar uma base já existente, faça backup e execute `database/migrate_topics.sql`. O script normaliza nomes conhecidos e apresenta registros restantes para revisão manual. Nenhuma pergunta é apagada automaticamente.

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| GET | `/health` | Verifica conectividade com o banco |
| GET | `/api/temas` | Lista temas oficiais existentes |
| GET | `/api/perguntas?limite=10` | Lista perguntas aleatórias |
| GET | `/api/perguntas?tema=Tecnologia&limite=10` | Filtra por tema |
| GET | `/api/perguntas/1` | Busca uma pergunta sem revelar resposta correta |
| POST | `/api/perguntas` | Cria pergunta e alternativas |
| POST | `/api/perguntas/1/resposta` | Confere alternativa selecionada |
| DELETE | `/api/perguntas/1` | Exclui pergunta e alternativas |

### Criar pergunta

`POST /api/perguntas`, `Content-Type: application/json`:

```json
{
  "cabecalho": "Qual linguagem é usada com Flutter?",
  "tema": "Tecnologia",
  "alternativas": [
    {"texto_alternativa": "Dart", "correta": true},
    {"texto_alternativa": "Java", "correta": false},
    {"texto_alternativa": "C#", "correta": false},
    {"texto_alternativa": "Ruby", "correta": false}
  ]
}
```

São aceitas de 2 a 6 alternativas e exatamente uma correta.

### Verificar resposta

`POST /api/perguntas/1/resposta`:

```json
{"id_alternativa": 1}
```

Resposta:

```json
{"correta": true}
```

## Integração Flutter

- Web/Windows no mesmo computador: `http://localhost:8080/api`
- Emulador Android: `http://10.0.2.2:8080/api`
- Celular físico: `http://IP_DO_COMPUTADOR:8080/api`

O middleware permite CORS para desenvolvimento. Em produção, restrinja as origens permitidas.

## Escopo atual

O banco contém perguntas e alternativas. Não há usuários, autenticação, histórico de partidas, ranking, pontuação persistente ou preferências de usuário. O Flutter calcula os resultados da sessão localmente. A tela Desafios permanece como Em desenvolvimento.
