import 'package:budget_intelli/core/core.dart';
import 'package:fpdart/fpdart.dart';

/// The base interface for all use cases in the application.
/// A use case represents a single unit of business logic.
abstract interface class UseCase<Type, Params> {
  /// Executes the use case with the given parameters.
  /// Returns a [Future] that resolves to an [Either] object containing either a [Failure] or the result of the use case.
  Future<Either<Failure, Type>> call(Params params);
}

/// A marker class used to indicate that a use case does not require any parameters.
class NoParams {}
