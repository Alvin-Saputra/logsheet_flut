import 'dart:developer';

import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:mysql_client/mysql_client.dart';

class RfiMySQLService {

  Future<List<Map<String, dynamic>>> fetchRFI() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        return [];
      }
      connection = connResult.connection!;
      final result = await connection.execute("SELECT * FROM m_rfi");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log("$e");
      return [];
    } finally {
      await closeMySQLConnection(connection);
    }
  }
}
