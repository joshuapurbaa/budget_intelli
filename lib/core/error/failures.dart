class Failure {
  Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  DatabaseFailure([super.message = 'Database Failure']);
}

// firebase failure
class FirebaseFailure extends Failure {
  FirebaseFailure([super.message = 'Firebase Failure']);
}
