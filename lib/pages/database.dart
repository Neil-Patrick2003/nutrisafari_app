import 'package:mysql1/mysql1.dart';

class MySQLHelper {
  // Database connection settings
  static final _settings = ConnectionSettings(
    host: '10.0.2.2:8000', // For Android Emulator; use 'localhost' for iOS
    port: 3306,
    user: 'root',
    password: '',
    db: 'nutrisafari',
  );

  // Method to test the connection to the database
  static Future<bool> testConnection() async {
    try {
      final conn = await MySqlConnection.connect(_settings);
      await conn.close();
      return true; // Connection successful
    } catch (e) {
      print('Error connecting to the database: $e');
      return false; // Connection failed
    }
  }

  // Method to execute a query
  static Future<Results> query(String sql, [List<dynamic>? values]) async {
    final conn = await MySqlConnection.connect(_settings);
    final results = await conn.query(sql, values);
    await conn.close();
    return results;
  }
}