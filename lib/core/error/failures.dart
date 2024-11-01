class Failure {
  Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  // ignore: use_super_parameters
  DatabaseFailure([this.message = 'Database Failure']) : super(message);
  @override
  // ignore: overridden_fields
  final String message;
}

// firebase failure
class FirebaseFailure extends Failure {
  // ignore: use_super_parameters
  FirebaseFailure([this.message = 'Firebase Failure']) : super(message);
  @override
  // ignore: overridden_fields
  final String message;
}
