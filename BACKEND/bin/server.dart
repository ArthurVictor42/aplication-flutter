import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:quiz_motion_backend/src/config/database.dart';
import 'package:quiz_motion_backend/src/config/env.dart';
import 'package:quiz_motion_backend/src/http/response.dart';
import 'package:quiz_motion_backend/src/questions/controllers/question_controller.dart';
import 'package:quiz_motion_backend/src/questions/repositories/question_repository.dart';
import 'package:quiz_motion_backend/src/questions/routes/question_routes.dart';
import 'package:quiz_motion_backend/src/questions/services/question_service.dart';
import 'package:quiz_motion_backend/src/questions/services/question_service_impl.dart';

Future<void> main() async {
  await Env.load();

  final host = Env.get('API_HOST', fallback: '0.0.0.0');
  final port = Env.getInt('API_PORT', fallback: 8080);

  // Composição das dependências: Repository -> Service -> Controller -> Routes.
  final repository = QuestionRepository();
  final QuestionService service = QuestionServiceImpl(repository);
  final controller = QuestionController(service);
  final router = QuestionRoutes(controller).router;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler((Request request) async {
    if (request.method == 'OPTIONS') {
      return Response(204, headers: {
        'access-control-allow-origin': '*',
        'access-control-allow-headers': 'Origin, Content-Type, Accept, Authorization',
        'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
      });
    }
    try {
      return await router(request);
    } catch (e, stackTrace) {
      stderr.writeln('Erro não tratado: $e\n$stackTrace');
      return jsonResponse(500, {'erro': 'Erro interno inesperado.'});
    }
  });

  try {
    await Database.connection();
    stdout.writeln('Conexão inicial com MySQL estabelecida.');
  } catch (e) {
    stderr.writeln('Aviso: não foi possível conectar ao MySQL: $e');
    stderr.writeln('Confira DB_HOST, DB_PORT, DB_NAME, DB_USER e DB_PASSWORD no .env.');
  }

  final server = await shelf_io.serve(handler, host, port);
  stdout.writeln('Quiz Motion API executando em http://${server.address.host}:$port');
  stdout.writeln('Teste no navegador: http://localhost:$port/health');

  ProcessSignal.sigint.watch().listen((_) async {
    await server.close(force: true);
    await Database.close();
    exit(0);
  });
}
