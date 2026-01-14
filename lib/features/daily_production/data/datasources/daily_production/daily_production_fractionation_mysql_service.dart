import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class DailyProductionFractionationMySQLService {
  // Future<bool> insertTicket(List<DailyProductionFractionationEntity> entity) async {
  //   MySQLConnection? connection;

  //   try {
  //     var connResult = await getMySQLConnection();
  //     if (connResult.connection == null) {
  //       log(
  //         '(Daily Production Fractionation MySQL) Failed to get MySQL connection for insert ticket.',
  //       );
  //       return false;
  //     }

  //     connection = connResult.connection;
  //     List<String> columns = [];
  //     List<String> params = [];
  //     final Map<String, dynamic> entityData = entity.toMap();
  //     final Map<String, dynamic> sqlExecuteParams = {};

  //     entityData.forEach((keyInEntityMap, value) {
  //       String actualDbColumnName = keyInEntityMap;
  //       String safeParameterName = keyInEntityMap;
  //       dynamic formattedValue = value;

  //       columns.add('`$actualDbColumnName`');
  //       params.add(':$safeParameterName');
  //       sqlExecuteParams[safeParameterName] = formattedValue;
  //     });

  //     final String sql =
  //         'INSERT INTO t_daily_production_fractionation (${columns.join(', ')}) VALUES (${params.join(', ')})';
  //     log('Generated SQL: $sql');
  //     log('Data for SQL: $sqlExecuteParams');
  //     log(
  //       connection!.connected
  //           ? "Connected to the database"
  //           : "Not Connected to the database",
  //     );
  //     final result = await connection.execute(sql, sqlExecuteParams);

  //     return result.affectedRows > BigInt.from(0);
  //   } catch (e) {
  //     log('Error inserting Quality Report Refinery Report: $e');
  //     return false;
  //   } finally {
  //     try {
  //       await closeMySQLConnection(connection);
  //       log("Is still connected: ${connection?.connected}");
  //     } catch (e) {
  //       log('Error closing connection: $e');
  //     }
  //   }
  // }

  Future<bool> insertTicket(
    List<DailyProductionFractionationEntity> entities,
  ) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        throw Exception("Gagal terhubung ke database");
      }

      connection = connResult.connection;

      await connection!.transactional((txn) async {
        for (var item in entities) {
          // ===============================
          // 1️⃣ CEK DUPLIKAT DATA
          // ===============================
          final duplicateCheckSql = """
          SELECT id
          FROM t_daily_production_fractionation
          WHERE plant = :plant
            AND transaction_date = :transaction_date
            AND work_center = :work_center
            AND shift = :shift
            AND no = :no
            AND (flag IS NULL OR flag = 'T')
          LIMIT 1
        """;

          final duplicateCheckResult = await txn.execute(duplicateCheckSql, {
            "plant": item.plant,
            "transaction_date": DateFormat(
              'yyyy-MM-dd',
            ).format(item.transactionDate ?? DateTime.now()),
            "work_center": item.workCenter,
            "shift": item.shift,
            "no": item.no, // ⚠️ sesuaikan nama kolom
          });

          if (duplicateCheckResult.rows.isNotEmpty) {
            // ⛔ STOP PROCESS + ROLLBACK
            throw Exception(
              "Data Dengan Plant, Tanggal, No, Shift, dan Work Center yang sama sudah ada",
            );
          }

          // ===============================
          // 2️⃣ INSERT DATA
          // ===============================
          final Map<String, dynamic> entityData = item.toMap();
          final List<String> columns = [];
          final List<String> values = [];
          final Map<String, dynamic> params = {};

          entityData.forEach((key, value) {
            if (value != null) {
              columns.add('`$key`');
              values.add(':$key');
              params[key] = value;
            }
          });

          final insertSql = """
          INSERT INTO t_daily_production_fractionation
          (${columns.join(', ')})
          VALUES (${values.join(', ')})
        """;

          await txn.execute(insertSql, params);
        }
      });

      return true;
    } catch (e) {
      // ⬅️ JANGAN return false di sini
      // ⬅️ Lempar ulang agar Provider tahu pesan error-nya
      log('Insert ticket error: $e');
      rethrow;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  // Future<List<Map<String, dynamic>>> getAllTickets(
  //   DateTime? dateFilter,
  //   String? time,
  //   String username,
  //   String role,
  //   String plantCode,
  // ) async {
  //   MySQLConnection? connection;

  //   try {
  //     final connResult = await getMySQLConnection();
  //     if (connResult.connection == null) {
  //       log('Failed to get MySQL connection for get all reports.');
  //       return [];
  //     }

  //     connection = connResult.connection;
  //     String baseQuery;
  //     final Map<String, dynamic> params = {};

  //     // PERBAIKAN UTAMA DI SINI:
  //     // Gunakan "SELECT a.*" agar ID yang diambil adalah ID Tiket (dari tabel a),
  //     // bukan ID Product (dari tabel b).
  //     //
  //     // Tambahkan "b.raw_material as oil_type_rm_name" jika Anda ingin menampilkan
  //     // nama produk, bukan kodenya. Sesuaikan 'raw_material' dengan nama kolom asli di DB Anda.

  //     String selectColumns = "a.*";

  //     // Jika Anda butuh nama produk muncul di UI (bukan kodenya), tambahkan baris di bawah ini:
  //     // selectColumns += ", b.raw_material as oil_type_rm_name, b.finish_good as oil_type_fgs_name";

  //     // Logika Query disederhanakan karena strukturnya sama untuk semua role
  //     // yang membedakan hanya otorisasi aksesnya.
  //     switch (role) {
  //       case 'LEAD':
  //       case 'LEAD_PROD':
  //       case 'OPR':
  //       case 'OPR_PROD':
  //       case 'MGR':
  //       case 'MGR_PROD':
  //       case 'ADM':
  //         baseQuery = """
  //           SELECT
  //               $selectColumns
  //           FROM
  //               t_daily_production_fractionation AS a

  //           WHERE
  //               a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
  //         """;
  //         params["plantCode"] = plantCode;
  //         break;

  //       default:
  //         log('User role $role is not authorized to view reports.');
  //         return [];
  //     }

  //     // Add date and time filters to the query
  //     if (dateFilter != null) {
  //       // Cek apakah sudah ada WHERE (seharusnya sudah ada dari baseQuery di atas)
  //       // tapi untuk keamanan logika string concatenation:
  //       if (baseQuery.contains("WHERE")) {
  //         baseQuery += " AND a.transaction_date = :reportDate";
  //       } else {
  //         baseQuery += " WHERE a.transaction_date = :reportDate";
  //       }
  //       params["reportDate"] =
  //           dateFilter; // Pastikan format tanggal sesuai tipe data DB (biasanya String yyyy-MM-dd)
  //     }

  //     if (time != null) {
  //       // Asumsi kolom di database bernama 'time' atau field lain yang relevan
  //       // Sesuaikan jika nama kolomnya berbeda (misal: a.jam_input)
  //       if (baseQuery.contains("WHERE")) {
  //         baseQuery += " AND a.time = :time";
  //       } else {
  //         baseQuery += " WHERE a.time = :time";
  //       }
  //       params["time"] = time;
  //     }

  //     baseQuery += " ORDER BY a.transaction_date DESC";

  //     // Debugging: Lihat query final di console
  //     // log('Final Query: $baseQuery');

  //     final IResultSet result = await connection!.execute(baseQuery, params);

  //     log(
  //       'Fetched ${result.rows.length} reports for user $username with role $role.',
  //     );

  //     return result.rows.map((row) => row.assoc()).toList();
  //   } catch (e) {
  //     log('Error fetching all reports: $e');
  //     return [];
  //   } finally {
  //     try {
  //       await closeMySQLConnection(connection);
  //       // log("Is still connected: ${connection?.connected}");
  //     } catch (e) {
  //       log('Error closing connection: $e');
  //     }
  //   }
  // }

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

      // 1. Definisikan kolom yang ingin diambil
      // a.* mengambil semua data transaksi (termasuk ID tiket yang benar)
      // b.* mengambil nama-nama produk dari master data
      String selectColumns = """
          a.*, 
          b.raw_material AS oil_type_rm_name,
          c.finish_good AS oil_type_fgs_name,
          d.finish_good AS oil_type_fgh_name
      """;

      // 2. Definisikan Base Query & Join
      // Menggunakan LEFT JOIN agar jika data produk terhapus di master,
      // tiket transaksi tetap muncul (hanya nama produknya null).
      String fromAndJoin = """
          FROM t_daily_production_fractionation AS a
          LEFT JOIN m_product AS b ON a.oil_type_rm = b.id
          LEFT JOIN m_product AS c ON a.oil_type_fgs = c.id
          LEFT JOIN m_product AS d ON a.oil_type_fgh = d.id
      """;

      // 3. Logic Role (Switch Case hanya mengatur WHERE clause)
      String whereClause = "";

      switch (role) {
        case 'LEAD':
        case 'LEAD_PROD':
        case 'OPR':
        case 'OPR_PROD':
        case 'MGR':
        case 'MGR_PROD':
        case 'ADM':
          // Admin dan user operational logic-nya mirip untuk 'read',
          // bedanya biasanya di akses tombol edit/approve (di handle UI).
          // Filter dasar: Plant Code & Flag
          whereClause =
              "WHERE a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')";
          params["plantCode"] = plantCode;
          break;

        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }

      // 4. Tambahan Filter Date & Time
      if (dateFilter != null) {
        // Karena kita menggunakan String builder, pastikan spasi di awal " AND..."
        whereClause += " AND a.transaction_date = :reportDate";

        // Konversi DateTime ke String format MySQL (yyyy-MM-dd) jika perlu,
        // atau biarkan driver menangani jika tipenya sudah DateTime.
        // Disarankan format string agar aman:
        params["reportDate"] = DateFormat('yyyy-MM-dd').format(dateFilter);
      }

      if (time != null) {
        // Asumsi ada kolom 'time' atau field terkait jam
        whereClause += " AND a.time = :time";
        params["time"] = time;
      }

      // 5. Susun Query Akhir
      baseQuery =
          "SELECT $selectColumns $fromAndJoin $whereClause ORDER BY a.transaction_date DESC";

      // Debugging: Cek query di console jika ada error
      // log("Running Query: $baseQuery");
      // log("Params: $params");

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
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'PFM'",
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
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'PFM'";
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

  // Future<bool> updateTicket(List<DailyProductionFractionationEntity> entity) async {
  //   return true;
  // MySQLConnection? connection;
  // try {
  //   final connResult = await getMySQLConnection();
  //   if (connResult.connection == null) {
  //     log('Failed to get MySQL connection for updating ticket.');
  //     return false;
  //   }

  //   connection = connResult.connection;

  //   final entityData = entity.toMap();
  //   final List<String> setClause = [];
  //   final Map<String, dynamic> sqlExecuteParams = {};

  //   entityData.forEach((keyInEntityMap, value) {
  //     if (keyInEntityMap != 'id') {
  //       String actualDbColumnName = keyInEntityMap;
  //       String safeParameterName = keyInEntityMap;

  //       setClause.add('`$actualDbColumnName` = :$safeParameterName');
  //       sqlExecuteParams[safeParameterName] = value;
  //     }
  //   });
  //   sqlExecuteParams['id'] = entity.id;

  //   final sql =
  //       "UPDATE t_daily_production_fractionation SET ${setClause.join(', ')} WHERE id = :id";

  //   log('Generated UPDATE SQL: $sql');
  //   log('Params for SQL: $sqlExecuteParams');

  //   final result = await connection!.execute(sql, sqlExecuteParams);
  //   log('ticket updated: ${result.affectedRows} row(s) affected.');
  //   return result.affectedRows > BigInt.from(0);
  // } catch (e) {
  //   log('Error updating report: $e');
  //   return false;
  // } finally {
  //   try {
  //     await closeMySQLConnection(connection);
  //   } catch (e) {
  //     log('$e');
  //   }
  // }
  // }

  Future<bool> updateTicket(
    List<DailyProductionFractionationEntity> entities,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('(MySQL) Failed to get connection for updating tickets.');
        return false;
      }

      connection = connResult.connection;

      // Gunakan Transaction. Ini PENTING untuk operasi batch.
      await connection!.transactional((txn) async {
        for (var item in entities) {
          // 1. CEK KEBERADAAN DATA (Apakah ID ini sudah ada?)
          final checkSql =
              "SELECT id FROM t_daily_production_fractionation WHERE id = :id";
          final checkResult = await txn.execute(checkSql, {"id": item.id});

          bool isExists = checkResult.rows.isNotEmpty;

          // Siapkan Data
          final Map<String, dynamic> entityData = item.toMap();
          final Map<String, dynamic> sqlExecuteParams = {};

          if (isExists) {
            // --- LOGIKA UPDATE ---
            // Data sudah ada, lakukan UPDATE
            final List<String> setClause = [];

            entityData.forEach((key, value) {
              // Kita tidak update ID, dan sebaiknya tidak update created_by/date jika tidak perlu
              if (key != 'id' && key != 'entry_by' && key != 'entry_date') {
                String safeParam = "u_$key"; // prefix u_ agar unik parameternya
                setClause.add('`$key` = :$safeParam');
                sqlExecuteParams[safeParam] = value;
              }
            });

            sqlExecuteParams['id'] = item.id; // Parameter untuk WHERE

            final updateSql =
                "UPDATE t_daily_production_fractionation SET ${setClause.join(', ')} WHERE id = :id";

            log('Updating ID: ${item.id}');
            await txn.execute(updateSql, sqlExecuteParams);
          } else {
            // --- LOGIKA INSERT ---
            // Data belum ada (item baru ditambahkan saat edit), lakukan INSERT
            List<String> columns = [];
            List<String> valuesPlaceholder = [];

            entityData.forEach((key, value) {
              if (value != null) {
                // Hanya insert yg tidak null
                String safeParam = "i_$key";
                columns.add('`$key`');
                valuesPlaceholder.add(':$safeParam');
                sqlExecuteParams[safeParam] = value;
              }
            });

            final insertSql =
                "INSERT INTO t_daily_production_fractionation (${columns.join(', ')}) VALUES (${valuesPlaceholder.join(', ')})";

            log('Inserting New Item ID: ${item.id}');
            await txn.execute(insertSql, sqlExecuteParams);
          }
        }
      });

      log('Success updating/inserting ${entities.length} items.');
      return true;
    } catch (e) {
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
  // Future<bool> sendApproveRejectTicket(
  //   final String username,
  //   final String status,
  //   final String userRole,
  //   final String shift,
  //   final String? remark,
  //   final String plant,
  //   final String transaction_date
  // ) async {
  //   MySQLConnection? connection;
  //   try {
  //     final connResult = await getMySQLConnection();
  //     if (connResult.connection == null) {
  //       log(
  //         'Failed to get MySQL connection for Sending approve/reject Daily Production Fractionation report.',
  //       );
  //       return false;
  //     }
  //     connection = connResult.connection;
  //     final date = DateTime.now();
  //     String sql;
  //     Map<String, dynamic> params;

  //     if (AppRoles.managerProd.contains(userRole)) {
  //       sql =
  //           "UPDATE t_daily_production_fractionation SET verified_by = :username, verified_status = :status, verified_date = :date, checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";
  //       params = {
  //         "username": username,
  //         "status": status,
  //         "date": date,
  //         "remark": remark,
  //         "id": id,
  //       };
  //     } else {
  //       sql =
  //           "UPDATE t_daily_production_fractionation SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";
  //       params = {
  //         "username": username,
  //         "status": status,
  //         "date": date,
  //         "remark": remark,
  //         "id": id,
  //       };
  //     }
  //     final result = await connResult.connection!.execute(sql, params);
  //     log("Query Sent: $sql");
  //     log("Affected Rows: ${result.affectedRows}");
  //     return result.affectedRows > BigInt.from(0);
  //   } catch (e) {
  //     log("$e");
  //     return false;
  //   } finally {
  //     try {
  //       await closeMySQLConnection(connection);
  //     } catch (e) {
  //       log("$e");
  //     }
  //   }
  // }

  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final String shift,
    final String? remark,
    final String plant,
    final String transaction_date,
    final String work_center, // Assumes format 'YYYY-MM-DD'
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for Sending approve/reject Daily Production Fractionation report.',
        );
        return false;
      }
      connection = connResult.connection;
      final date = DateTime.now();
      String sql;

      // We prepare the common parameters first
      final Map<String, dynamic> params = {
        "username": username,
        "status": status,
        "date": date,
        "remark": remark,
        "plant": plant,
        "shift": shift,
        "transaction_date": transaction_date,
        "work_center": work_center,
      };

      if (AppRoles.managerProd.contains(userRole)) {
        // Logic for Manager: Updates Verified and Checked columns
        sql = """
        UPDATE t_daily_production_fractionation 
        SET 
          verified_by = :username, 
          verified_status = :status, 
          verified_date = :date, 
          checked_by = :username, 
          checked_status = :status, 
          checked_date = :date, 
          checked_status_remarks = :remark 
        WHERE 
          plant = :plant 
          AND shift = :shift 
          AND DATE(transaction_date) = :transaction_date
          AND work_center = :work_center
      """;
      } else {
        // Logic for Operator/Lead: Updates Prepared columns
        sql = """
        UPDATE t_daily_production_fractionation 
        SET 
          prepared_by = :username, 
          prepared_status = :status, 
          prepared_date = :date, 
          prepared_status_remarks = :remark 
        WHERE 
          plant = :plant 
          AND shift = :shift 
          AND DATE(transaction_date) = :transaction_date
          AND work_center = :work_center
      """;
      }

      final result = await connResult.connection!.execute(sql, params);
      log("Query Sent: $sql");
      log("Params: $params");
      log("Affected Rows: ${result.affectedRows}");

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log("Error sending approve/reject: $e");
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log("Error closing connection: $e");
      }
    }
  }

  // Future<List<Map<String, dynamic>>> getReportsForManager(
  //   String plantCode,
  // ) async {
  //   MySQLConnection? connection;
  //   try {
  //     final connResult = await getMySQLConnection();
  //     if (connResult.connection == null) {
  //       log('Failed to get MySQL connection for get reports for manager.');
  //       return [];
  //     }
  //     connection = connResult.connection;
  //     const sql = """
  //       SELECT
  //           a.id,
  //           a.company,
  //           a.plant,
  //           a.transaction_date,
  //           a.posting_date,
  //           a.work_center,
  //           a.shift,
  //           a.oil_type_rm AS oil_type_rm_id,
  //           b.raw_material AS oil_type_rm,
  //           a.oil_type_rm_no,
  //           a.oil_type_rm_cr,
  //           a.oil_type_rm_from_tank,
  //           a.oil_type_rm_awal_jam,
  //           a.oil_type_rm_awal_flowmeter,
  //           a.oil_type_rm_akhir_jam,
  //           a.oil_type_rm_akhir_flowmeter,
  //           a.oil_type_rm_total,
  //           a.oil_type_fgs AS oil_type_fgs_id,
  //           b.finish_good AS oil_type_fgs,
  //           a.oil_type_fgs_no,
  //           a.oil_type_fgs_cr,
  //           a.oil_type_fgs_awal_jam,
  //           a.oil_type_fgs_awal_flowmeter,
  //           a.oil_type_fgs_akhir_jam,
  //           a.oil_type_fgs_akhir_flowmeter,
  //           a.oil_type_fgs_total,
  //           a.oil_type_fgs_to_tank,
  //           a.oil_type_fgh AS oil_type_fgh_id,
  //           b.by_product AS oil_type_bp,
  //           a.oil_type_fgh_no,
  //           a.oil_type_fgh_awal_jam,
  //           a.oil_type_fgh_awal_flowmeter,
  //           a.oil_type_fgh_akhir_jam,
  //           a.oil_type_fgh_akhir_flowmeter,
  //           a.oil_type_fgh_total,
  //           a.oil_type_fgh_to_tank,
  //           a.remarks,
  //           a.flag,
  //           a.uu_item,
  //           a.uu_budget_ref_qty,
  //           a.uu_flowmeter_before,
  //           a.uu_flowmeter_after,
  //           a.uu_flowmeter_total,
  //           a.uu_yield_percent,
  //           a.uu_listrik,
  //           a.uu_air,
  //           a.entry_by,
  //           a.entry_date,
  //           a.prepared_by,
  //           a.prepared_date,
  //           a.prepared_status,
  //           a.prepared_status_remarks,
  //           a.verified_by,
  //           a.verified_date,
  //           a.verified_status,
  //           a.verified_status_remarks,
  //           a.checked_by,
  //           a.checked_date,
  //           a.checked_status,
  //           a.checked_status_remarks,
  //           a.form_no,
  //           a.date_issued,
  //           a.revision_no,
  //           a.revision_date
  //       FROM
  //           t_daily_production_fractionation AS a
  //       JOIN
  //           m_product AS b
  //       ON a.oil_type_rm = b.id
  //       WHERE a.prepared_status = 'Approved' AND a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
  //       ORDER BY posting_date DESC
  //     """;
  //     final result = await connection!.execute(sql, {"plantCode": plantCode});
  //     log("Fetched ${result.rows.length} reports for manager.");
  //     return result.rows.map((row) => row.assoc()).toList();
  //   } catch (e) {
  //     log('Error fetching reports for manager: $e');
  //     return [];
  //   } finally {
  //     try {
  //       await closeMySQLConnection(connection);
  //     } catch (e) {
  //       log("$e");
  //     }
  //   }
  // }

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

      // 1. Definisikan kolom yang ingin diambil
      // a.* mengambil semua data transaksi (termasuk ID tiket yang benar)
      // b.* mengambil nama-nama produk dari master data
      String selectColumns = """
          a.*, 
          b.raw_material AS oil_type_rm_name,
          c.finish_good AS oil_type_fgs_name,
          d.finish_good AS oil_type_fgh_name
      """;

      // 2. Definisikan Base Query & Join
      // Menggunakan LEFT JOIN agar jika data produk terhapus di master,
      // tiket transaksi tetap muncul (hanya nama produknya null).
      String fromAndJoin = """
          FROM t_daily_production_fractionation AS a
          LEFT JOIN m_product AS b ON a.oil_type_rm = b.id
          LEFT JOIN m_product AS c ON a.oil_type_fgs = c.id
          LEFT JOIN m_product AS d ON a.oil_type_fgh = d.id
      """;

      // 3. Logic Role (Switch Case hanya mengatur WHERE clause)
      String whereClause = "";

      whereClause =
          "WHERE a.plant = :plantCode AND a.prepared_status = 'Approved' AND (a.flag IS NULL OR a.flag = 'T')";
      params["plantCode"] = plantCode;

      // 5. Susun Query Akhir
      baseQuery =
          "SELECT $selectColumns $fromAndJoin $whereClause ORDER BY a.transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      log('Fetched ${result.rows.length} reports for user manager.');

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

  Future<bool> deleteTicket(
    String username,
    String shift,
    String plant,
    String transaction_date,
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
        "UPDATE t_daily_production_fractionation SET flag = 'D', prepared_by= :username, prepared_status = :prepared_status, prepared_date = :prepared_date WHERE transaction_date = :transaction_date AND plant = :plant AND shift = :shift",
        {
          "username": username,
          "prepared_status": "Deleted",
          "prepared_date": "${DateTime.now()}",
          "transaction_date": transaction_date,
          "plant": plant,
          "shift": shift,
        },
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
          """SELECT * FROM t_daily_production_fractionation AND (flag IS NULL OR flag = 'T')""";

      final result = await connection!.execute(baseQuery);
      log("Fetched ${result.rows.length} reports for Daily Production.");
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

  Future<List<Map<String, dynamic>>> getTickets(
    DateTime? dateFilter,
    String plantCode, {
    String? shift = "All",
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for getTickets.');
        return [];
      }
      connection = connResult.connection;
      String query = """
          SELECT
              a.id,
              a.company,
              a.plant,
              a.transaction_date,
              a.posting_date,
              a.work_center,
              a.shift,
              a.oil_type_rm AS oil_type_rm_id,
              b.raw_material AS oil_type_rm,
              a.oil_type_rm_no,
              a.oil_type_rm_cr,
              a.oil_type_rm_from_tank,
              a.oil_type_rm_awal_jam,
              a.oil_type_rm_awal_flowmeter,
              a.oil_type_rm_akhir_jam,
              a.oil_type_rm_akhir_flowmeter,
              a.oil_type_rm_total,
              a.oil_type_fgs AS oil_type_fgs_id,
              b.finish_good AS oil_type_fgs,
              a.oil_type_fgs_no,
              a.oil_type_fgs_cr,
              a.oil_type_fgs_awal_jam,
              a.oil_type_fgs_awal_flowmeter,
              a.oil_type_fgs_akhir_jam,
              a.oil_type_fgs_akhir_flowmeter,
              a.oil_type_fgs_total,
              a.oil_type_fgs_to_tank,
              a.oil_type_fgh AS oil_type_fgh_id,
              b.by_product AS oil_type_bp,
              a.oil_type_fgh_no,
              a.oil_type_fgh_awal_jam,
              a.oil_type_fgh_awal_flowmeter,
              a.oil_type_fgh_akhir_jam,
              a.oil_type_fgh_akhir_flowmeter,
              a.oil_type_fgh_total,
              a.oil_type_fgh_to_tank,
              a.remarks,
              a.flag,
              a.uu_item,
              a.uu_budget_ref_qty,
              a.uu_flowmeter_before,
              a.uu_flowmeter_after,
              a.uu_flowmeter_total,
              a.uu_yield_percent,
              a.uu_listrik,
              a.uu_air,
              a.entry_by,
              a.entry_date,
              a.prepared_by,
              a.prepared_date,
              a.prepared_status,
              a.prepared_status_remarks,
              a.verified_by,
              a.verified_date,
              a.verified_status,
              a.verified_status_remarks,
              a.checked_by,
              a.checked_date,
              a.checked_status,
              a.checked_status_remarks,
              a.form_no,
              a.date_issued,
              a.revision_no,
              a.revision_date
          FROM
              t_daily_production_fractionation AS a
          JOIN 
              m_product AS b
          ON a.oil_type_rm = b.id
          WHERE DATE(a.posting_date) = :dateFilter AND a.plant = :plantCode""";

      dateFilter ??= DateTime.now();

      final Map<String, dynamic> params = {
        "dateFilter": DateFormat('yyyy-MM-dd').format(dateFilter),
        "plantCode": plantCode,
      };
      log("Params: $params");

      if (shift != null && shift != "All") {
        query += " AND a.shift = :shift";
        params['shift'] = shift;
      }
      log("Query: $query");
      log("Params: $params");

      final IResultSet result = await connection!.execute(query, params);
      log("PFM Tickets fetched: ${result.rows.length}");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log(
        "(PFM MySQL) Error getting all Daily Production Fractionation tickets: $e",
      );
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('(PFM MySQL) MySQL connection closed for getTickets.');
      }
    }
  }
}
