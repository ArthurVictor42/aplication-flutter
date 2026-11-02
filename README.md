# Quiz Motion

Projeto acadêmico de aplicativo de perguntas e respostas.
Grupo: Arthur victor, Wagner Francisco, Kauã Santiago, Thiago Jose, Wallison Gabriel, João Victor
Link do figma: 

## Componentes

- `frontend/`: aplicativo Flutter.
- `BACKEND/`: API REST em Dart com Shelf.
- `BACKEND/database/`: schema inicial e migração segura dos temas.

## Temas oficiais

A experiência do aplicativo trabalha com três categorias: **Inglês**, **Gerais** e **Tecnologia**.

## Iniciar o projeto

1. Configure o MySQL e o arquivo `BACKEND/.env`.
2. Siga as instruções de `BACKEND/README.md` para iniciar a API.
3. Em outro terminal, siga `frontend/README.md` para iniciar o Flutter.

A API precisa estar ativa para cadastrar perguntas e iniciar rodadas.

## Arquitetura e fluxo

O Flutter chama a API por HTTP. No backend, as requisições seguem `Route → Controller → Service → Repository → MySQL`. As regras de negócio ficam em `QuestionServiceImpl`.

Durante uma rodada, as perguntas são carregadas do banco, as respostas são validadas pela API e o resumo é calculado no frontend. Não existe persistência de histórico, ranking ou sequência de dias nesta versão.

## Design

As referências visuais fornecidas estão em `frontend/assets/prototypes/`. Elas servem como material de comparação visual; as telas funcionais são implementadas em Flutter.
