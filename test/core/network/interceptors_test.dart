import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fieldops_mobile/core/error/failures.dart';
import 'package:fieldops_mobile/core/network/auth_interceptor.dart';
import 'package:fieldops_mobile/core/network/error_interceptor.dart';
import 'package:fieldops_mobile/core/storage/secure_token_store.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class MockSecureTokenStore extends Mock implements SecureTokenStore {}

/// A [RequestInterceptorHandler] that captures whether [next] or [reject]
/// was called, and what [RequestOptions] was forwarded.
class _CapturingRequestHandler extends RequestInterceptorHandler {
  RequestOptions? forwardedOptions;
  DioException? rejectedError;

  @override
  void next(RequestOptions options) {
    forwardedOptions = options;
  }

  @override
  void reject(DioException error, [bool callFollowingErrorInterceptor = false]) {
    rejectedError = error;
  }
}

/// A [ErrorInterceptorHandler] that captures the forwarded [DioException].
class _CapturingErrorHandler extends ErrorInterceptorHandler {
  DioException? forwardedError;

  @override
  void next(DioException err) {
    forwardedError = err;
  }
}

/// Returns a minimal [RequestOptions] for the given path.
RequestOptions _requestOptions(String path) =>
    RequestOptions(path: path, baseUrl: 'https://api.example.com');

// ---------------------------------------------------------------------------
// AuthInterceptor tests
// ---------------------------------------------------------------------------

void main() {
  late MockSecureTokenStore tokenStore;
  late AuthInterceptor authInterceptor;

  setUp(() {
    tokenStore = MockSecureTokenStore();
    authInterceptor = AuthInterceptor(tokenStore);
  });

  group('AuthInterceptor', () {
    test(
      'injects Authorization: Bearer header when a token is present',
      () async {
        const token = 'my.jwt.token';
        when(() => tokenStore.readToken()).thenAnswer((_) async => token);

        final options = _requestOptions('/projects');
        final handler = _CapturingRequestHandler();

        await authInterceptor.onRequest(options, handler);

        expect(
          handler.forwardedOptions?.headers['Authorization'],
          equals('Bearer $token'),
        );
      },
    );

    test(
      'does not add Authorization header when no token is stored',
      () async {
        when(() => tokenStore.readToken()).thenAnswer((_) async => null);

        final options = _requestOptions('/auth/login');
        final handler = _CapturingRequestHandler();

        await authInterceptor.onRequest(options, handler);

        expect(
          handler.forwardedOptions?.headers.containsKey('Authorization'),
          isFalse,
        );
      },
    );

    test(
      'does not add Authorization header when stored token is empty',
      () async {
        when(() => tokenStore.readToken()).thenAnswer((_) async => '');

        final options = _requestOptions('/auth/login');
        final handler = _CapturingRequestHandler();

        await authInterceptor.onRequest(options, handler);

        expect(
          handler.forwardedOptions?.headers.containsKey('Authorization'),
          isFalse,
        );
      },
    );

    test('always calls handler.next (never rejects)', () async {
      when(() => tokenStore.readToken()).thenAnswer((_) async => 'token');

      final handler = _CapturingRequestHandler();
      await authInterceptor.onRequest(_requestOptions('/any'), handler);

      expect(handler.forwardedOptions, isNotNull);
      expect(handler.rejectedError, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // ErrorInterceptor tests
  // ---------------------------------------------------------------------------

  group('ErrorInterceptor', () {
    late ErrorInterceptor errorInterceptor;

    setUp(() {
      errorInterceptor = ErrorInterceptor();
    });

    /// Builds a [DioException] for an HTTP response with the given status code.
    DioException _badResponse(int statusCode, {Object? body}) {
      final requestOptions = _requestOptions('/endpoint');
      return DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: statusCode,
          data: body,
        ),
      );
    }

    /// Runs [errorInterceptor.onError] and returns the forwarded [DioException].
    DioException _captureError(DioException input) {
      final handler = _CapturingErrorHandler();
      errorInterceptor.onError(input, handler);
      return handler.forwardedError!;
    }

    test('4xx response maps to ServerFailure with correct status code', () {
      for (final code in [400, 401, 403, 404, 422]) {
        final forwarded = _captureError(_badResponse(code));

        expect(forwarded.error, isA<ServerFailure>());
        final failure = forwarded.error as ServerFailure;
        expect(failure.statusCode, equals(code));
      }
    });

    test('5xx response maps to ServerFailure with correct status code', () {
      for (final code in [500, 502, 503]) {
        final forwarded = _captureError(_badResponse(code));

        expect(forwarded.error, isA<ServerFailure>());
        final failure = forwarded.error as ServerFailure;
        expect(failure.statusCode, equals(code));
      }
    });

    test('ServerFailure message is extracted from response body "message" key',
        () {
      final forwarded = _captureError(
        _badResponse(422, body: {'message': 'Validation failed'}),
      );

      final failure = forwarded.error as ServerFailure;
      expect(failure.message, equals('Validation failed'));
    });

    test('ServerFailure message falls back to generic text when body lacks key',
        () {
      final forwarded = _captureError(_badResponse(500));

      final failure = forwarded.error as ServerFailure;
      expect(failure.message, contains('500'));
    });

    test('connection timeout maps to NetworkFailure', () {
      final err = DioException(
        requestOptions: _requestOptions('/endpoint'),
        type: DioExceptionType.connectionTimeout,
      );
      final forwarded = _captureError(err);

      expect(forwarded.error, isA<NetworkFailure>());
    });

    test('receive timeout maps to NetworkFailure', () {
      final err = DioException(
        requestOptions: _requestOptions('/endpoint'),
        type: DioExceptionType.receiveTimeout,
      );
      final forwarded = _captureError(err);

      expect(forwarded.error, isA<NetworkFailure>());
    });

    test('connection error maps to NetworkFailure', () {
      final err = DioException(
        requestOptions: _requestOptions('/endpoint'),
        type: DioExceptionType.connectionError,
      );
      final forwarded = _captureError(err);

      expect(forwarded.error, isA<NetworkFailure>());
    });

    test('unknown DioException type maps to NetworkFailure', () {
      final err = DioException(
        requestOptions: _requestOptions('/endpoint'),
        type: DioExceptionType.unknown,
        message: 'something unexpected',
      );
      final forwarded = _captureError(err);

      expect(forwarded.error, isA<NetworkFailure>());
    });

    test('handler.next is always called (error is forwarded, never swallowed)',
        () {
      final handler = _CapturingErrorHandler();
      errorInterceptor.onError(
        _badResponse(400),
        handler,
      );

      expect(handler.forwardedError, isNotNull);
    });
  });
}
