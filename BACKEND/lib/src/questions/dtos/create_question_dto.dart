class CreateQuestionDto {
  const CreateQuestionDto({
    required this.header,
    required this.theme,
    required this.alternatives,
  });

  final String header;
  final String theme;
  final List<CreateAlternativeDto> alternatives;

  factory CreateQuestionDto.fromJson(Map<String, dynamic> json) {
    final rawAlternatives = json['alternativas'];
    if (rawAlternatives is! List) {
      throw const FormatException('O campo alternativas deve ser uma lista.');
    }

    final alternatives = <CreateAlternativeDto>[];
    for (final item in rawAlternatives) {
      if (item is! Map) {
        throw const FormatException('Cada alternativa deve ser um objeto JSON.');
      }
      alternatives.add(CreateAlternativeDto.fromJson(
        Map<String, dynamic>.from(item),
      ));
    }

    return CreateQuestionDto(
      header: (json['cabecalho'] ?? '').toString().trim(),
      theme: (json['tema'] ?? '').toString().trim(),
      alternatives: alternatives,
    );
  }
}

class CreateAlternativeDto {
  const CreateAlternativeDto({required this.text, required this.correct});

  final String text;
  final bool correct;

  factory CreateAlternativeDto.fromJson(Map<String, dynamic> json) {
    return CreateAlternativeDto(
      text: (json['texto_alternativa'] ?? '').toString().trim(),
      correct: json['correta'] == true,
    );
  }
}
