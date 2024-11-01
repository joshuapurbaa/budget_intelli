import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RepetitionDatabaseApi {
  Future<Unit> insertRepetitionDb(Repetition repetition);
  Future<Unit> insertRepetitionsDb(List<Repetition> repetitions);
  Future<List<Repetition>> getRepetitionListBySchedulePaymentId(
    String schedulePaymentId,
  );
  Future<Unit> updateRepetitionDb(Repetition repetition);
  Future<Unit> deleteRepetitionDb(String id);
  Future<Repetition?> getRepetitionDbById(String id);
}

class RepetitionDatabaseApiImpl implements RepetitionDatabaseApi {
  RepetitionDatabaseApiImpl(this.database);

  final SchedulePaymentDatabase database;

  @override
  Future<Unit> deleteRepetitionDb(String id) async {
    try {
      await database.database;
      await database.deleteRepetition(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Repetition?> getRepetitionDbById(String id) async {
    try {
      await database.database;
      final result = await database.getRepetitionById(id);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<Repetition>> getRepetitionListBySchedulePaymentId(
    String schedulePaymentId,
  ) async {
    try {
      await database.database;
      final result =
          await database.getRepetitionsBySchedulePaymentId(schedulePaymentId);
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertRepetitionDb(Repetition repetition) async {
    try {
      await database.database;
      await database.insertRepetition(repetition);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertRepetitionsDb(List<Repetition> repetitions) async {
    try {
      await database.database;
      await database.insertRepetitions(repetitions);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateRepetitionDb(Repetition repetition) async {
    try {
      await database.database;
      await database.updateRepetition(repetition);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
