import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Writes exception details (error + stack trace) to a local log file.
///
/// Stack traces are intentionally written to the file for debugging purposes
/// but are NEVER surfaced to the UI. The UI always receives only a generic
/// "Something went wrong" message (Requirement 13.3).
class LocalLogService {
  /// Singleton instance.
  static final LocalLogService instance = LocalLogService._();

  LocalLogService._();

  File? _logFile;

  /// Returns the log file, creating it inside the app's documents directory
  /// on first access.
  Future<File> _getLogFile() async {
    if (_logFile != null) return _logFile!;
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File('${dir.path}/fieldops_errors.log');
    return _logFile!;
  }

  /// Appends [error] and [stackTrace] to the local log file.
  ///
  /// Each entry is prefixed with an ISO-8601 timestamp. Errors here are
  /// written asynchronously and failures to write are silently swallowed so
  /// that a log-write failure never causes a secondary crash.
  Future<void> logException(Object error, StackTrace stackTrace) async {
    try {
      final file = await _getLogFile();
      final timestamp = DateTime.now().toIso8601String();
      final entry = StringBuffer()
        ..writeln('─' * 60)
        ..writeln('[$timestamp] ERROR: $error')
        ..writeln('STACK TRACE:')
        ..writeln(stackTrace)
        ..writeln();

      await file.writeAsString(
        entry.toString(),
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {
      // Silently swallow log-write failures — we must never crash the app
      // while trying to log another crash.
    }
  }
}
