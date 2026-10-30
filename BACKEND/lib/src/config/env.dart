import 'dart:io';

/// Carregador simples de variáveis de ambiente de um arquivo .env.
/// Variáveis já definidas no sistema operacional têm prioridade.
class Env {
  static Future<void> load([String path = '.env']) async {
    final file = File(path);
    if (!await file.exists()) return;

    for (final rawLine in await file.readAsLines()) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
        continue;
      }
      final separator = line.indexOf('=');
      final key = line.substring(0, separator).trim();
      var value = line.substring(separator + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
           (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      if (key.isNotEmpty) {
        Platform.environment; // Documenta que o ambiente do processo é suportado.
        // Não sobrescreve variáveis fornecidas pelo sistema operacional.
        if (_processValue(key) == null) _fileValues[key] = value;
      }
    }
  }

  static final Map<String, String> _fileValues = {};

  static String? _processValue(String key) {
    final value = Platform.environment[key];
    return value == null || value.isEmpty ? null : value;
  }

  static String get(String key, {String? fallback}) =>
      _processValue(key) ?? _fileValues[key] ?? fallback ?? '';

  static int getInt(String key, {required int fallback}) =>
      int.tryParse(get(key)) ?? fallback;
}
