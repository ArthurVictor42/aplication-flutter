import 'alternative_model.dart';

class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.header,
    required this.theme,
    required this.alternatives,
  });

  final int id;
  final String header;
  final String theme;
  final List<AlternativeModel> alternatives;

  Map<String, dynamic> toJson({bool includeCorrect = false}) {
    return {
      'id_questao': id,
      'cabecalho': header,
      'tema': theme,
      'alternativas': alternatives
          .map((alternative) => alternative.toJson(includeCorrect: includeCorrect))
          .toList(),
    };
  }
}
