import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QuizApiException implements Exception {
  const QuizApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class QuizApiService {
  QuizApiService._();

  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return 'http://localhost:8080/api';
    }
    return 'http://10.0.2.2:8080/api';
  }

  static Future<List<String>> listarTemas() async {
    final response = await _get('/temas');
    final data = _decodeList(response);
    return data.map((item) => (item['tema'] ?? '').toString())
        .where((tema) => tema.isNotEmpty).toList();
  }

  static Future<List<Map<String, dynamic>>> buscarPerguntas({
    String? tema,
    int limite = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/perguntas').replace(
      queryParameters: {
        if (tema != null && tema.isNotEmpty) 'tema': tema,
        'limite': '$limite',
      },
    );
    final response = await _request(() => http.get(uri));
    final body = _decode(response);
    if (response.statusCode != 200) {
      throw QuizApiException(_message(body, 'Não foi possível buscar perguntas.'));
    }
    final questions = body['perguntas'];
    if (questions is! List) {
      throw const QuizApiException('A API retornou uma lista de perguntas inválida.');
    }
    return questions.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> buscarPergunta(int id) async {
    final response = await _get('/perguntas/$id');
    return _decode(response);
  }

  static Future<Map<String, dynamic>> criarPergunta({
    required String cabecalho,
    required String tema,
    required List<Map<String, dynamic>> alternativas,
  }) async {
    final response = await _request(() => http.post(
      Uri.parse('$baseUrl/perguntas'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({
        'cabecalho': cabecalho,
        'tema': tema,
        'alternativas': alternativas,
      }),
    ));
    final body = _decode(response);
    if (response.statusCode != 201) {
      throw QuizApiException(_message(body, 'Não foi possível cadastrar a pergunta.'));
    }
    return body;
  }

  static Future<bool> verificarResposta({
    required int idPergunta,
    required int idAlternativa,
  }) async {
    final response = await _request(() => http.post(
      Uri.parse('$baseUrl/perguntas/$idPergunta/resposta'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({'id_alternativa': idAlternativa}),
    ));
    final body = _decode(response);
    if (response.statusCode != 200) {
      throw QuizApiException(_message(body, 'Não foi possível verificar a resposta.'));
    }
    return body['correta'] == true;
  }

  static Future<void> excluirPergunta(int id) async {
    final response = await _request(() => http.delete(Uri.parse('$baseUrl/perguntas/$id')));
    final body = _decode(response);
    if (response.statusCode != 200) {
      throw QuizApiException(_message(body, 'Não foi possível excluir a pergunta.'));
    }
  }

  static Future<http.Response> _get(String path) =>
      _request(() => http.get(Uri.parse('$baseUrl$path')));

  static Future<http.Response> _request(
    Future<http.Response> Function() send,
  ) async {
    try {
      return await send().timeout(const Duration(seconds: 12));
    } on Exception catch (error) {
      if (error is QuizApiException) rethrow;
      throw QuizApiException(
        'Não foi possível conectar à API. Verifique se o backend está ativo e se o endereço está correto.',
      );
    }
  }

  static Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
      throw const FormatException();
    } on FormatException {
      throw const QuizApiException('A API retornou uma resposta inválida.');
    }
  }

  static List<Map<String, dynamic>> _decodeList(http.Response response) {
    if (response.statusCode != 200) {
      final body = _decode(response);
      throw QuizApiException(_message(body, 'Não foi possível carregar os temas.'));
    }
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) throw const FormatException();
      return decoded.cast<Map<String, dynamic>>();
    } on FormatException {
      throw const QuizApiException('A API retornou uma lista de temas inválida.');
    }
  }

  static String _message(Map<String, dynamic> body, String fallback) =>
      (body['erro'] ?? body['mensagem'] ?? fallback).toString();
}
