import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../http/response.dart';
import '../dtos/create_question_dto.dart';
import '../services/question_service.dart';

class QuestionController {
  QuestionController(this.service);

  final QuestionService service;

  Future<Response> health(Request request) async {
    try {
      await service.listarTemas();
      return jsonResponse(200, {
        'status': 'ok',
        'mensagem': 'API e MySQL conectados.',
      });
    } catch (e, stackTrace) {
      print('Falha no health check: $e\n$stackTrace');
      return jsonResponse(503, {
        'status': 'erro',
        'mensagem': 'API ativa, mas não foi possível conectar ao MySQL. Confira o arquivo .env.',
      });
    }
  }

  Future<Response> listarTemas(Request request) async {
    try {
      return jsonResponse(200, (await service.listarTemas())
          .map((tema) => {'tema': tema}).toList());
    } catch (e, stackTrace) {
      print('Erro ao listar temas: $e\n$stackTrace');
      return serverError('Não foi possível listar os temas. Verifique o MySQL.');
    }
  }

  Future<Response> listar(Request request) async {
    try {
      final theme = request.url.queryParameters['tema'];
      final requestedLimit = int.tryParse(request.url.queryParameters['limite'] ?? '10') ?? 10;
      final limit = requestedLimit.clamp(1, 50).toInt();
      final questions = await service.listar(tema: theme, limite: limit);
      return jsonResponse(200, {
        'total': questions.length,
        'perguntas': questions.map((question) => question.toJson()).toList(),
      });
    } catch (e, stackTrace) {
      print('Erro ao listar perguntas: $e\n$stackTrace');
      return serverError('Não foi possível buscar perguntas. Verifique o MySQL.');
    }
  }

  Future<Response> buscarPorId(Request request, String id) async {
    try {
      final question = await service.buscarPorId(int.parse(id));
      if (question == null) return notFound('Pergunta não encontrada.');
      return jsonResponse(200, question.toJson());
    } on FormatException {
      return badRequest('ID inválido.');
    } catch (e, stackTrace) {
      print('Erro ao buscar pergunta: $e\n$stackTrace');
      return serverError('Não foi possível buscar a pergunta.');
    }
  }

  Future<Response> criar(Request request) async {
    try {
      final decoded = jsonDecode(await request.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return badRequest('O corpo da requisição deve ser um objeto JSON.');
      }
      final dto = CreateQuestionDto.fromJson(decoded);
      final created = await service.criar(dto);
      return jsonResponse(201, {
        'mensagem': 'Pergunta cadastrada com sucesso.',
        'pergunta': created.toJson(includeCorrect: true),
      });
    } on FormatException {
      return badRequest('JSON inválido ou estrutura de alternativas incorreta.');
    } on ArgumentError catch (e) {
      return badRequest(e.message.toString());
    } catch (e, stackTrace) {
      print('Erro ao cadastrar pergunta: $e\n$stackTrace');
      return serverError('Não foi possível cadastrar a pergunta. Consulte o terminal da API.');
    }
  }

  Future<Response> verificarResposta(Request request, String id) async {
    try {
      final decoded = jsonDecode(await request.readAsString());
      if (decoded is! Map) return badRequest('Envie um objeto JSON.');
      final alternativeId = int.tryParse('${decoded['id_alternativa'] ?? ''}');
      if (alternativeId == null) return badRequest('Informe id_alternativa.');
      final correct = await service.verificarResposta(int.parse(id), alternativeId);
      if (correct == null) return notFound('Pergunta ou alternativa não encontrada.');
      return jsonResponse(200, {'correta': correct});
    } on FormatException {
      return badRequest('JSON inválido.');
    } on ArgumentError catch (e) {
      return badRequest(e.message.toString());
    } catch (e, stackTrace) {
      print('Erro ao validar resposta: $e\n$stackTrace');
      return serverError('Não foi possível validar a resposta.');
    }
  }

  Future<Response> excluir(Request request, String id) async {
    try {
      final deleted = await service.excluir(int.parse(id));
      if (!deleted) return notFound('Pergunta não encontrada.');
      return jsonResponse(200, {'mensagem': 'Pergunta excluída com sucesso.'});
    } on ArgumentError catch (e) {
      return badRequest(e.message.toString());
    } catch (e, stackTrace) {
      print('Erro ao excluir pergunta: $e\n$stackTrace');
      return serverError('Não foi possível excluir a pergunta.');
    }
  }
}
