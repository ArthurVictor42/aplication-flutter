class AlternativeModel {
  const AlternativeModel({
    this.id,
    required this.text,
    required this.correct,
  });

  final int? id;
  final String text;
  final bool correct;

  Map<String, dynamic> toJson({bool includeCorrect = false}) {
    return {
      if (id != null) 'id_alternativa': id,
      'texto_alternativa': text,
      if (includeCorrect) 'correta': correct,
    };
  }
}
