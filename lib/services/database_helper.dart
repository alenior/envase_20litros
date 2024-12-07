import 'package:mysql1/mysql1.dart';
import 'package:logger/logger.dart';

class DatabaseHelper {
  static final Logger logger = Logger();

  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'Naodigo@2024',
      db: 'envase_20litros',
    );

    try {
      final conn = await MySqlConnection.connect(settings);
      logger.i('🔌 Conectado ao banco de dados: ${settings.db}');
      return conn;
    } catch (e) {
      logger.e('❌ Erro ao conectar ao banco de dados: $e');
      rethrow;
    }
  }
}
