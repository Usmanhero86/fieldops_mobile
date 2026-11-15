import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_token_store.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

/// Configured [Dio] HTTP client for the FieldOps application.
///
/// Wires together:
/// - 30-second timeouts (connect / send / receive) per design spec
/// - [AuthInterceptor]: injects `Authorization: Bearer <token>` on every
///   request when a session token is available; skips the header for
///   unauthenticated routes (e.g. `/auth/login`)
/// - [ErrorInterceptor]: maps [DioException] → [ServerFailure] or
///   [NetworkFailure] so callers never need to inspect raw Dio errors
class DioClient {
  DioClient({required SecureTokenStore tokenStore}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([AuthInterceptor(tokenStore), ErrorInterceptor()]);
  }

  late final Dio dio;
}
