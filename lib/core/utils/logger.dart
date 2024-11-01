import 'package:logger/logger.dart';

void appLogger({
  required String from,
  required Object error,
  required StackTrace stackTrace,
  String? message,
  String? code,
}) {
  Logger(
    printer: PrettyPrinter(),
  ).e(
    'from: $from, message: $message, code: $code',
    error: error,
    stackTrace: stackTrace,
  );
}
