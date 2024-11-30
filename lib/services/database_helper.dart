import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'Naodigo@2024',
      db: 'envase_20litros',
    );
    return await MySqlConnection.connect(settings);
  }
}
