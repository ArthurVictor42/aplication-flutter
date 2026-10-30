
import 'package:mysql_dart/mysql_dart.dart';

import 'env.dart';

class Database {
  Database._();

  static MySQLConnection? _connection;

  static Future<MySQLConnection> connection() async {
    if (_connection != null && _connection!.connected) {
      return _connection!;
    }

    final conn = await MySQLConnection.createConnection(
      host: Env.get('DB_HOST', fallback: '127.0.0.1'),
      port: Env.getInt('DB_PORT', fallback: 3306),
      userName: Env.get('DB_USER', fallback: 'root'),
      password: Env.get('DB_PASSWORD'),
      databaseName: Env.get('DB_NAME', fallback: 'questionapp'),
      allowPublicKeyRetrieval: true,
    );

    await conn.connect();
    _connection = conn;

    return conn;
  }

  static Future<void> close() async {
    final current = _connection;
    _connection = null;

    if (current != null && current.connected) {
      await current.close();
    }
  }
}
