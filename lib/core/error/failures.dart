import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Failure hierarchy
// ---------------------------------------------------------------------------

/// Base class for all domain failures.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

/// Failure caused by a network issue (timeout, no connectivity, etc.).
final class NetworkFailure extends Failure {
  const NetworkFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure returned when the backend responds with an error status code.
final class ServerFailure extends Failure {
  const ServerFailure({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  List<Object?> get props => [statusCode, message];
}

/// Failure caused by a local Drift/SQLite database error.
final class LocalDbFailure extends Failure {
  const LocalDbFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure produced when form-field validation does not pass.
///
/// [fieldErrors] maps each invalid field name to a human-readable error string.
final class ValidationFailure extends Failure {
  const ValidationFailure({required this.fieldErrors});

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [fieldErrors];
}

/// Failure returned when a device permission required for an operation
/// has been denied or permanently denied.
final class PermissionFailure extends Failure {
  const PermissionFailure({required this.permissionName});

  final String permissionName;

  @override
  List<Object?> get props => [permissionName];
}

// ---------------------------------------------------------------------------
// Result<T> — a minimal Either<Failure, T> without external packages
// ---------------------------------------------------------------------------

/// A discriminated union that holds either a [Failure] (left / error) or a
/// success value of type [T] (right / ok).
///
/// Usage:
/// ```dart
/// Result<AuthUser> result = Success(user);
/// Result<AuthUser> result = Err(NetworkFailure(message: 'timeout'));
///
/// switch (result) {
///   case Success(:final value): // use value
///   case Err(:final failure): // handle failure
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// The success variant of [Result].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// The failure variant of [Result].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
