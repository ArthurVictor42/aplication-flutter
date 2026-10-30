import '../dtos/create_question_dto.dart';
import '../models/question_model.dart';
import '../repositories/question_repository.dart';
import 'question_service.dart';

class QuestionServiceImpl implements QuestionService {
  QuestionServiceImpl(this.repository);
  final QuestionRepository repository;

  @override
  Future<List<String>> listarTemas() => repository.listarTemas();

  @override
  Future<List<QuestionModel>> listar({String? tema, int limite = 10}) {
    if (limite < 1 || limite > 50) {
      throw ArgumentError('O limite deve estar entre 1 e 50.');
    }
    return repository.listar(tema: tema, limite: limite);
  }

  @override
  Future<QuestionModel?> buscarPorId(int id) {
    if (id < 1) throw ArgumentError('O ID deve ser maior que zero.');
    return repository.buscarPorId(id);
  }

  @override
  Future<QuestionModel> criar(CreateQuestionDto dto) {
    if (dto.header.isEmpty || dto.header.length > 200) {
      throw ArgumentError('Informe uma pergunta com até 200 caracteres.');
    }
    if (dto.theme.isEmpty || dto.theme.length > 30) {
      throw ArgumentError('Informe um tema com até 30 caracteres.');
    }
    if (dto.alternatives.length < 2 || dto.alternatives.length > 6) {
      throw ArgumentError('Envie entre 2 e 6 alternativas.');
    }

    var correctCount = 0;
    final alternatives = <Map<String, dynamic>>[];
    for (final alternative in dto.alternatives) {
      if (alternative.text.isEmpty || alternative.text.length > 100) {
        throw ArgumentError('Cada alternativa deve ter entre 1 e 100 caracteres.');
      }
      if (alternative.correct) correctCount++;
      alternatives.add({
        'texto_alternativa': alternative.text,
        'correta': alternative.correct,
      });
    }
    if (correctCount != 1) {
      throw ArgumentError('Marque exatamente uma alternativa como correta.');
    }

    return repository.criar(
      cabecalho: dto.header,
      tema: dto.theme,
      alternativas: alternatives,
    );
  }

  @override
  Future<bool> excluir(int id) async {
    if (id < 1) throw ArgumentError('O ID deve ser maior que zero.');
    return repository.excluir(id);
  }

  @override
  Future<bool?> verificarResposta(int questionId, int alternativeId) async {
    if (questionId < 1 || alternativeId < 1) {
      throw ArgumentError('Os IDs devem ser maiores que zero.');
    }
    final question = await repository.buscarPorId(questionId);
    if (question == null) return null;
    final belongsToQuestion = question.alternatives.any(
      (alternative) => alternative.id == alternativeId,
    );
    if (!belongsToQuestion) {
      throw ArgumentError('A alternativa não pertence a esta pergunta.');
    }
    return repository.verificarResposta(questionId, alternativeId);
  }
}
