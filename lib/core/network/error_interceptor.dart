import 'package:dio/dio.dart';

import '../error/failures.dart';

/// Maps [DioException] instances to typed [Failure] objects and rethrows them
/// as a [DioException] carrying the failure in [DioException.error].
///
/// Mapping rules
/// ─────────────
/// • Connection timeout / send timeout / receive timeout / connection error
///   (i.e. no HTTP response at all)  →  [NetworkFailure]
///
/// • Any response with an HTTP status code (4xx, 5xx)  →  [ServerFailure]
///   The status code and response message (or a generic fallback) are
///   preserved so callers can distinguish 400/422 (non-retryable) from
///   5xx (retryable) without re-parsing the raw exception.
///
/// • Unknown / unexpected Dio errors  →  [NetworkFailure] with a generic
///   message, so the rest of the app never needs to handle raw [DioException].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);

    // Wrap the failure back into a DioException so the caller's try/catch on
    // DioException still works, but the typed Failure is accessible via
    // `exception.error`.
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        message: failure is NetworkFailure
            ? failure.message
            : (failure as ServerFailure).message,
      ),
    );
  }

  static Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure(
          message: 'Connection timed out. Please check your internet connection.',
        );

      case DioExceptionType.sendTimeout:
        return const NetworkFailure(
          message: 'Request timed out while sending data.',
        );

      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Server did not respond in time. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkFailure(
          message: 'Unable to reach the server. Please check your connection.',
        );

      case DioExceptionType.badResponse:
        final response = err.response;
        final statusCode = response?.statusCode ?? 0;
        final message = _extractMessage(response) ??
            'Server returned an error (HTTP $statusCode).';
        return ServerFailure(statusCode: statusCode, message: message);

      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          message: 'SSL certificate verification failed.',
        );

      case DioExceptionType.unknown:
      default:
        return NetworkFailure(
          message: err.message ?? 'An unexpected network error occurred.',
        );
    }
  }

  /// Tries to extract a human-readable message from the response body.
  ///
  /// Handles the common `{ "message": "..." }` and `{ "error": "..." }`
  /// shapes. Returns `null` if extraction fails so the caller can fall back
  /// to a generic string.
  static String? _extractMessage(Response<dynamic>? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'] ?? data['error'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    } catch (_) {
      // Ignore — fall through to null.
    }
    return null;
  }
}
