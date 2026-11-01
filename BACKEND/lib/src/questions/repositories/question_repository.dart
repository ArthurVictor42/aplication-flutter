import '../../config/database.dart';
import '../models/alternative_model.dart';
import '../models/question_model.dart';

class QuestionRepository {
  int _toInt(dynamic value) => int.parse(value.toString());

  bool _toBool(dynamic value) =>
      value == true || value.toString() == '1' || value.toString() == 'true';

  Future<List<String>> listarTemas() async {
    final db = await Database.connection();
    final result = await db.execute(
      'SELECT DISTINCT tema FROM question ORDER BY tema ASC',
    );
    return result.rows
        .map((row) => (row.assoc()['tema'] ?? '').toString())
        .toList();
  }

  Future<List<QuestionModel>> listar({String? tema, int limite = 10}) async {
    final db = await Database.connection();
    final result = tema != null && tema.trim().isNotEmpty
        ? await db.execute(
            'SELECT id_questao, cabecalho, tema FROM question '
            'WHERE tema = ? ORDER BY RAND() LIMIT ?',
            [tema.trim(), limite],
          )
        : await db.execute(
            'SELECT id_questao, cabecalho, tema FROM question '
            'ORDER BY RAND() LIMIT ?',
            [limite],
          );

    final questions = <QuestionModel>[];
    for (final row in result.rows) {
      final data = row.assoc();
      final id = _toInt(data['id_questao']);
      questions.add(
        QuestionModel(
          id: id,
          header: data['cabecalho'] ?? '',
          theme: data['tema'] ?? '',
          alternatives: await _listarAlternativas(id),
        ),
      );
    }
    return questions;
  }

  Future<QuestionModel?> buscarPorId(int id) async {
    final db = await Database.connection();
    final result = await db.execute(
      'SELECT id_questao, cabecalho, tema FROM question WHERE id_questao = ?',
      [id],
    );
    if (result.rows.isEmpty) return null;

    final data = result.rows.first.assoc();
    return QuestionModel(
      id: _toInt(data['id_questao']),
      header: data['cabecalho'] ?? '',
      theme: data['tema'] ?? '',
      alternatives: await _listarAlternativas(id),
    );
  }

  Future<List<AlternativeModel>> _listarAlternativas(int questionId) async {
    final db = await Database.connection();
    final result = await db.execute(
      'SELECT id_alternativa, texto_alternativa, correta '
      'FROM alternativa WHERE id_questao = ? ORDER BY id_alternativa',
      [questionId],
    );
    return result.rows.map((row) {
      final data = row.assoc();
      return AlternativeModel(
        id: _toInt(data['id_alternativa']),
        text: data['texto_alternativa'] ?? '',
        correct: _toBool(data['correta']),
      );
    }).toList();
  }

  Future<QuestionModel> criar({
    required String cabecalho,
    required String tema,
    required List<Map<String, dynamic>> alternativas,
  }) async {
    final db = await Database.connection();
    return db.transactional((tx) async {
      final inserted = await tx.execute(
        'INSERT INTO question (cabecalho, tema) VALUES (?, ?)',
        [cabecalho, tema],
      );
      final id = inserted.lastInsertID.toInt();

      final createdAlternatives = <AlternativeModel>[];
      for (final alternative in alternativas) {
        final text = alternative['texto_alternativa'] as String;
        final correct = alternative['correta'] == true;
        final insertedAlternative = await tx.execute(
          'INSERT INTO alternativa '
          '(id_questao, texto_alternativa, correta) VALUES (?, ?, ?)',
          [id, text, correct ? 1 : 0],
        );
        createdAlternatives.add(
          AlternativeModel(
            id: insertedAlternative.lastInsertID.toInt(),
            text: text,
            correct: correct,
          ),
        );
      }

      return QuestionModel(
        id: id,
        header: cabecalho,
        theme: tema,
        alternatives: createdAlternatives,
      );
    });
  }

  Future<bool> excluir(int id) async {
    final db = await Database.connection();
    return db.transactional((tx) async {
      final found = await tx.execute(
        'SELECT id_questao FROM question WHERE id_questao = ?',
        [id],
      );
      if (found.rows.isEmpty) return false;
      await tx.execute('DELETE FROM alternativa WHERE id_questao = ?', [id]);
      await tx.execute('DELETE FROM question WHERE id_questao = ?', [id]);
      return true;
    });
  }

  Future<bool?> verificarResposta(int questionId, int alternativeId) async {
    final db = await Database.connection();
    final result = await db.execute(
      'SELECT correta FROM alternativa '
      'WHERE id_questao = ? AND id_alternativa = ?',
      [questionId, alternativeId],
    );
    if (result.rows.isEmpty) return null;
    return _toBool(result.rows.first.assoc()['correta']);
  }
}
