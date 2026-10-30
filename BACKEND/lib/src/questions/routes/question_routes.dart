import 'package:shelf_router/shelf_router.dart';

import '../controllers/question_controller.dart';

class QuestionRoutes {
  QuestionRoutes(this.controller);

  final QuestionController controller;

  Router get router {
    final router = Router();
    router.get('/health', controller.health);
    router.get('/api/temas', controller.listarTemas);
    router.get('/api/perguntas', controller.listar);
    router.get('/api/perguntas/<id|[0-9]+>', controller.buscarPorId);
    router.post('/api/perguntas', controller.criar);
    router.post('/api/perguntas/<id|[0-9]+>/resposta', controller.verificarResposta);
    router.delete('/api/perguntas/<id|[0-9]+>', controller.excluir);
    return router;
  }
}
