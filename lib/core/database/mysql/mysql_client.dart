import 'dart:async';
import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

MySQLConnection? _connection;

Future<({MySQLConnection? connection, String? error})>
getMySQLConnection() async {
  if (_connection != null) {
    try {
      // Validasi fisik: Kirim query ringan untuk cek apakah server merespon
      await _connection!.execute("SELECT 1");
      log('Reusing verified MySQL connection');
      return (connection: _connection, error: null);
    } catch (e) {
      log('Existing connection is stale, creating new one...');
      _connection = null; // Koneksi lama mati, hapus agar buat baru
    }
  }
  final isAWS = "T"; // "T" if use aws RDS
  final MySQLConnection? conn;
  if (isAWS == "T") {
    conn = await MySQLConnection.createConnection(
      // AWS
      host: dotenv.env['DB_HOST'],
      userName: dotenv.env['DB_USER']!,
      password: dotenv.env['DB_PASSWORD']!,
      databaseName: dotenv.env['DB_NAME'],
      port: int.parse(dotenv.env['DB_PORT']!),
      secure: true,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException(
          'Koneksi ke database gagal: Waktu koneksi habis. Pastikan perangkat Anda terhubung ke jaringan yang benar dan IP database dapat dijangkau.',
        );
      },
    );
  } else {
    // KPN
    conn = await MySQLConnection.createConnection(
      // AWS
      host: dotenv.env['DB_HOST_KPN'],
      userName: dotenv.env['DB_USER_KPN']!,
      password: dotenv.env['DB_PASSWORD_KPN']!,
      databaseName: dotenv.env['DB_NAME_KPN'],
      port: int.parse(dotenv.env['DB_PORT_KPN']!),
      secure: false,
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException(
          'Koneksi ke database gagal: Waktu koneksi habis. Pastikan perangkat Anda terhubung ke jaringan yang benar dan IP database dapat dijangkau.',
        );
      },
    );
  }
  try {
    await conn.connect();
    _connection = conn;
    log('Connected to MySQL');
    return (connection: _connection, error: null);
  } on TimeoutException catch (e) {
    return (connection: null, error: e.message);
  } catch (e) {
    log('Error connecting to MySQL: $e');
    conn.close;
    _connection = null;
    return (
      connection: null,
      error:
          'Koneksi ke database gagal: Terjadi masalah jaringan atau konfigurasi. (${e.toString()})',
    );
  }
}

Future<void> closeMySQLConnection([MySQLConnection? connection]) async {
  // 1. Cek apakah variabel _connection ada isinya
  if (_connection != null) {
    try {
      // 2. Hanya panggil .close() jika statusnya benar-benar masih terhubung
      if (_connection!.connected) {
        await _connection!.close();
        log('MySQL connection closed successfully.');
      } else {
        log('MySQL connection was already closed or not established.');
      }
    } catch (e) {
      // 3. Jika gagal menutup, log saja, jangan biarkan aplikasi crash
      log('Info: Connection already in inactive state, safe to ignore.');
    } finally {
      // 4. YANG PALING PENTING: Pastikan variabel global diatur ke null
      // agar proses berikutnya bisa membuat koneksi baru dengan bersih
      _connection = null;
    }
  }
}
