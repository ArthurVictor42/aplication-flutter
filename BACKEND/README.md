# Quiz Motion — Backend

API REST em Dart com Shelf e MySQL. A aplicação utiliza camadas para separar HTTP, regras de negócio e persistência.

## Requisitos e configuração

- Dart SDK compatível com o `pubspec.yaml`.
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
├── config/                 # conexão MySQL e carregamento do .env
├── http/                   # respostas JSON padronizadas
└── questions/
    ├── controllers/        # tradução HTTP -> chamadas do serviço
    ├── dtos/               # validação estrutural/conversão do JSON recebido
    ├── models/             # modelos de pergunta e alternativa
    ├── repositories/       # SQL e transações MySQL
    ├── routes/             # definição dos endpoints Shelf
    └── services/
        ├── question_service.dart       # contrato (interface)
        └── question_service_impl.dart  # regras de negócio
```

## Fluxo interno

`Request HTTP → Route → Controller → DTO (quando aplicável) → QuestionService → QuestionServiceImpl → QuestionRepository → MySQL`.

- **Routes** registram os caminhos e direcionam para o controller.
- **Controller** interpreta parâmetros e corpo HTTP, chama o serviço e transforma o resultado em resposta HTTP.
- **DTO** converte o JSON de criação para objetos tipados.
- **Service** define o contrato da funcionalidade.
- **ServiceImpl** aplica regras: limites, campos obrigatórios, quantidade de alternativas e exatamente uma resposta correta.
- **Repository** executa consultas e transações SQL.
- **Models** representam os dados e controlam a serialização JSON.

A criação de uma pergunta e suas alternativas ocorre em uma transação: se uma inserção falhar, o banco reverte o conjunto.

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| GET | `/health` | Verifica conectividade com o banco |
| GET | `/api/temas` | Lista temas existentes |
| GET | `/api/perguntas?limite=10` | Lista perguntas aleatórias |
| GET | `/api/perguntas?tema=Tecnologia&limite=10` | Filtra por tema |
| GET | `/api/perguntas/1` | Busca uma pergunta |
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

## Escopo e limitações

O schema atual contém perguntas, alternativas e temas derivados. Não há usuários, autenticação, histórico de partidas, ranking, pontuação persistente ou preferências de usuário. O frontend calcula o resultado da sessão localmente. Para implementar recursos persistentes, será necessário modelar essas entidades e criar endpoints específicos.
