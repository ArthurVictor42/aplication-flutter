import '../dtos/create_question_dto.dart';
import '../models/question_model.dart';

abstract interface class QuestionService {
  Future<List<String>> listarTemas();
  Future<List<QuestionModel>> listar({String? tema, int limite = 10});
  Future<QuestionModel?> buscarPorId(int id);
  Future<QuestionModel> criar(CreateQuestionDto dto);
  Future<bool> excluir(int id);
  Future<bool?> verificarResposta(int questionId, int alternativeId);
}
