class CustomException implements Exception {
  CustomException(
    this.message, {
    this.statusCode,
  });
  final String message;
  final String? statusCode;

  @override
  String toString() {
    return 'CustomException: $message';
  }
}
