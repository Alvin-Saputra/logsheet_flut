import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DailyProductionRefineryMySQLService {
  Future<bool> insertTicket(
    List<DailyProductionRefineryEntity> entities,
  ) async {
    if (entities.isEmpty) return false;

    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        throw Exception("Gagal terhubung ke database");
      }
      connection = connResult.connection;

      // Jalankan dalam Transaction agar atomik (semua berhasil atau semua gagal)
      await connection!.transactional((txn) async {
        // Cek duplikasi berdasarkan Grouping ID (asumsi ID dibuat di client/provider)
        // Atau cek duplikasi bisnis (tanggal, plant, dll) jika diperlukan.
        // Disini kita insert setiap baris.

        for (var item in entities) {
          final Map<String, dynamic> entityData = item.toMap();
          final List<String> columns = [];
          final List<String> values = [];
          final Map<String, dynamic> params = {};

          entityData.forEach((key, value) {
            // Kita skip ticket_id agar DB yang handle auto increment
            if (key != 'ticket_id' && value != null) {
              columns.add('`$key`');
              values.add(':$key');
              params[key] = value;
            }
          });

          final insertSql =
              'INSERT INTO t_daily_production_refinery (${columns.join(', ')}) VALUES (${values.join(', ')})';
          await txn.execute(insertSql, params);
        }
      });

      return true;
    } catch (e) {
      log('Insert ticket error: $e');
      // Rethrow agar UI/Provider bisa menangkap error-nya
      rethrow;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }

      connection = connResult.connection;
      String baseQuery;
      final Map<String, dynamic> params = {};

      String selectColumns = """
          a.*, 
          a.oil_type_fg AS oil_type_fg_id,
          a.oil_type_rm AS oil_type_rm_id,
          a.bp_oil_type AS bp_oil_type_id,
          b.raw_material AS oil_type_rm,
          c.finish_good AS oil_type_fg,
          d.by_product AS bp_oil_type
      """;

      String fromAndJoin = """
          FROM t_daily_production_refinery AS a
          LEFT JOIN m_product AS b ON a.oil_type_rm = b.id
          LEFT JOIN m_product AS c ON a.oil_type_fg = c.id
          LEFT JOIN m_product AS d ON a.bp_oil_type = d.id
      """;

      String whereClause = "";

      switch (role) {
        case 'LEAD':
        case 'LEAD_PROD':
        case 'OPR':
        case 'OPR_PROD':
        case 'MGR':
        case 'MGR_PROD':
        case 'ADM':
          whereClause =
              "WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')";
          params["plantCode"] = plantCode;
          break;

        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }

      if (dateFilter != null) {
        whereClause += " AND DATE(a.transaction_date) = :reportDate";

        params["reportDate"] = DateFormat('yyyy-MM-dd').format(dateFilter);
      }

      if (time != null) {
        // Asumsi ada kolom 'time' atau field terkait jam
        whereClause += " AND a.time = :time";
        params["time"] = time;
      }

      baseQuery =
          "SELECT $selectColumns $fromAndJoin $whereClause ORDER BY a.transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      log(
        'Fetched ${result.rows.length} reports for user $username with role $role.',
      );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all reports: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return null;
      }
      connection = connResult.connection;
      final result = await connection!.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'PRM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log("ticket id from database: ${row['ticket']}");

        return latestId;
      }
      await closeMySQLConnection(connection);
      return null;
    } catch (e) {
      log('Error fetching latest ticket id: $e');
      return null;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }

      connection = connResult.connection!;

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'PRM'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connection.execute(sql, params);
      log(
        'Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating autonumber: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateTicket(
    List<DailyProductionRefineryEntity> entities,
    List<int> deletedTicketIds, // List ID yang akan dihapus
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('(MySQL) Failed to get connection for updating tickets.');
        return false;
      }

      connection = connResult.connection;

      // Mulai Transaksi
      await connection!.transactional((txn) async {
        // ---------------------------------------------------------
        // 1. LOGIKA DELETE (Ditambahkan)
        // Jalankan ini terlebih dahulu dalam transaksi yang sama
        // ---------------------------------------------------------
        if (deletedTicketIds.isNotEmpty) {
          log('Processing deletions for ${deletedTicketIds.length} items...');

          for (var id in deletedTicketIds) {
            // Query delete standar
            final deleteSql =
                "UPDATE t_daily_production_refinery SET flag = 'D' WHERE ticket_id = :id";

            // Eksekusi delete
            await txn.execute(deleteSql, {"id": id});
          }
          log('Deleted IDs: $deletedTicketIds');
        }

        // ---------------------------------------------------------
        // 2. LOGIKA UPSERT (INSERT / UPDATE) - Kode Lama Anda
        // ---------------------------------------------------------
        for (var item in entities) {
          // Cek Keberadaan Data
          final checkSql =
              "SELECT id FROM t_daily_production_refinery WHERE id = :id AND shift = :shift AND no=:no AND flag != 'D'";
          final checkResult = await txn.execute(checkSql, {
            "id": item.id,
            "shift": item.shift,
            "no": item.no,
          });

          bool isExists = checkResult.rows.isNotEmpty;

          // Siapkan Data
          final Map<String, dynamic> entityData = item.toMap();
          final Map<String, dynamic> sqlExecuteParams = {};

          if (isExists) {
            // --- UPDATE ---
            final List<String> setClause = [];

            entityData.forEach((key, value) {
              if (key != 'id' && key != 'entry_by' && key != 'entry_date') {
                String safeParam = "u_$key";
                setClause.add('`$key` = :$safeParam');
                sqlExecuteParams[safeParam] = value;
              }
            });

            sqlExecuteParams['ticket_id'] = item.ticketId;

            final updateSql =
                "UPDATE t_daily_production_refinery SET ${setClause.join(', ')} WHERE ticket_id = :ticket_id";

            log('Updating ID: ${item.id}');
            await txn.execute(updateSql, sqlExecuteParams);
          } else {
            // --- INSERT ---
            List<String> columns = [];
            List<String> valuesPlaceholder = [];

            entityData.forEach((key, value) {
              if (value != null) {
                String safeParam = "i_$key";
                columns.add('`$key`');
                valuesPlaceholder.add(':$safeParam');
                sqlExecuteParams[safeParam] = value;
              }
            });

            final insertSql =
                "INSERT INTO t_daily_production_refinery (${columns.join(', ')}) VALUES (${valuesPlaceholder.join(', ')})";

            log('Inserting New Item ID: ${item.id}');
            await txn.execute(insertSql, sqlExecuteParams);
          }
        }
      });

      log(
        'Success transaction: Updated/Inserted ${entities.length}, Deleted ${deletedTicketIds.length}.',
      );
      return true;
    } catch (e) {
      // Jika ada error pada delete ATAU update/insert, SEMUA akan di-rollback
      log('Error during updateTicket transaction (Rolled Back): $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  // TODO: FUNCTIONS IMPORTED
  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final String shift,
    final String? remark,
    final String id,
    final bool changeUncompletedTicket,
    final bool approveAllShift,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for Sending approve/reject Daily Production Refinery report.',
        );
        return false;
      }
      connection = connResult.connection;
      final date = DateTime.now();

      String? sql;
      Map<String, dynamic>? params;

      final completedSql = changeUncompletedTicket ? ", is_completed = 1" : "";
      final shiftCondition = approveAllShift ? "" : " AND shift = :shift";



      if (AppRoles.managerProd.contains(userRole)) {
        sql = """
      UPDATE t_daily_production_refinery 
      SET 
        verified_by = :username, 
        verified_status = :status, 
        verified_date = :date, 
        checked_by = :username, 
        checked_status = :status, 
        checked_date = :date, 
        checked_status_remarks = :remark
        $completedSql
      WHERE id = :id AND flag != 'D' $shiftCondition
      """;

        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
          "shift":shift
        };
      } else if (AppRoles.leadProd.contains(userRole)) {
        sql = """
      UPDATE t_daily_production_refinery 
      SET 
        prepared_by = :username, 
        prepared_status = :status, 
        prepared_date = :date, 
        prepared_status_remarks = :remark
        $completedSql
      WHERE id = :id AND flag != 'D' $shiftCondition
      """;

        params = {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
          "shift":shift
        };
      }

      final result = await connResult.connection!.execute(sql ?? "", params);
      log("Query Sent: $sql");
      log("Affected Rows: ${result.affectedRows}");
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("$e");
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log("$e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReportsForManager(
    String plantCode,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }

      connection = connResult.connection;
      String baseQuery;
      final Map<String, dynamic> params = {};

      String selectColumns = """
          a.*, 
          a.oil_type_fg AS oil_type_fg_id,
          a.oil_type_rm AS oil_type_rm_id,
          a.bp_oil_type AS bp_oil_type_id,
          b.raw_material AS oil_type_rm,
          c.finish_good AS oil_type_fg,
          d.by_product AS bp_oil_type
      """;

      String fromAndJoin = """
          FROM t_daily_production_refinery AS a
          LEFT JOIN m_product AS b ON a.oil_type_rm = b.id
          LEFT JOIN m_product AS c ON a.oil_type_fg = c.id
          LEFT JOIN m_product AS d ON a.bp_oil_type = d.id
      """;

      String whereClause = "";

      whereClause =
          "WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')";
      params["plantCode"] = plantCode;

      baseQuery =
          "SELECT $selectColumns $fromAndJoin $whereClause ORDER BY a.transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      // log(
      //   'Fetched ${result.rows.length} reports for user $username with role $role.',
      // );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all report for manager: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> deleteTicket(
    String username,
    String id,
    String shift,
    String plant,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log("Failed to get MySQL connection for deleting ticket");
        return false;
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "UPDATE t_daily_production_refinery SET flag = 'D' WHERE id = :id AND plant = :plant AND shift = :shift",
        {"username": username, "plant": plant, "shift": shift, "id": id},
      );
      log('Ticket berhasil dihapus: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error closing connection: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReportsById() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      String baseQuery = "";

      baseQuery =
          "SELECT * FROM t_daily_production_refinery AND (flag IS NULL OR flag = 'T')";

      final result = await connection!.execute(baseQuery);
      log("Fetched ${result.rows.length} reports for Daily production.");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('$e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error Closing Connection: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }

      connection = connResult.connection;
      String baseQuery;
      final Map<String, dynamic> params = {};

      String selectColumns = """
          a.*, 
          a.oil_type_fg AS oil_type_fg_id,
          a.oil_type_rm AS oil_type_rm_id,
          a.bp_oil_type AS bp_oil_type_id,
          b.raw_material AS oil_type_rm,
          c.finish_good AS oil_type_fg,
          d.by_product AS bp_oil_type
      """;

      String fromAndJoin = """
          FROM t_daily_production_refinery AS a
          LEFT JOIN m_product AS b ON a.oil_type_rm = b.id
          LEFT JOIN m_product AS c ON a.oil_type_fg = c.id
          LEFT JOIN m_product AS d ON a.bp_oil_type = d.id
      """;

      String whereClause = "";

      whereClause =
          "WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')";
      params["plantCode"] = plantCode;

      if (dateFilter != null) {
        whereClause += " AND DATE(a.transaction_date) = :reportDate";

        params["reportDate"] = DateFormat('yyyy-MM-dd').format(dateFilter);
      }

      baseQuery =
          "SELECT $selectColumns $fromAndJoin $whereClause ORDER BY a.transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      // log(
      //   'Fetched ${result.rows.length} reports for user $username with role $role.',
      // );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all report for manager: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }
}
