import 'package:dio/dio.dart';

import '../storage/secure_token_store.dart';

/// Attaches a Bearer token to every outgoing request.
///
/// If [SecureTokenStore] returns a non-null token the interceptor adds:
///   `Authorization: Bearer <token>`
///
/// If no token is present (e.g. the `/auth/login` request before the first
/// login) the request is forwarded unchanged — unauthenticated routes work
/// without an Authorization header.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore);

  final SecureTokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
