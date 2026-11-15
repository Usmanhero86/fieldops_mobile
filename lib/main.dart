import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/utils/local_log_service.dart';
import 'injection_container/injection_container.dart';

Future<void> main() async {
  // Ensures Flutter engine is initialised before any platform channel calls.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise all GetIt dependencies before the widget tree is built.
  await setupInjection();

  // Catch all uncaught Flutter framework errors (widget build failures,
  // layout errors, etc.) and log them to the local log file.
  // The UI never sees the stack trace — only a generic message is shown
  // (Requirement 13.3).
  FlutterError.onError = (FlutterErrorDetails details) {
    LocalLogService.instance.logException(
      details.exception,
      details.stack ?? StackTrace.empty,
    );
    // In debug mode let the default handler also print to console; in
    // release mode suppress the red error screen entirely.
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  // Catch all uncaught asynchronous errors that escape the widget tree
  // (e.g. errors thrown in isolates or platform callbacks).
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    LocalLogService.instance.logException(error, stack);
    return true; // returning true suppresses the default crash behaviour
  };

  // runZonedGuarded catches any remaining synchronous or async errors inside
  // the zone that both FlutterError.onError and onError might miss.
  runZonedGuarded(() => runApp(const FieldOpsApp()), (
    Object error,
    StackTrace stack,
  ) {
    LocalLogService.instance.logException(error, stack);
  });
}
