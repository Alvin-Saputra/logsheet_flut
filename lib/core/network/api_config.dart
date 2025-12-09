// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:8000/api',
          //  baseUrl: 'https://logsheet-dev.gamasap.com/api',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      ) {
    // Bisa tambahkan Interceptor untuk logging atau menyisipkan Token
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Dio get dio => _dio;
}
