import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SchedulePaymentDatabaseApi {
  Future<Unit> insertSchedulePaymentApi(SchedulePayment schedulePayment);
  Future<List<SchedulePayment>> getSchedulePaymentsApi();
  Future<SchedulePayment?> getSchedulePaymentByIdApi(String id);
  Future<Unit> updateSchedulePayment(SchedulePayment schedulePayment);
  Future<Unit> deleteSchedulePaymentByIdApi(String id);
}

class SchedulePaymentDatabaseApiImpl implements SchedulePaymentDatabaseApi {
  SchedulePaymentDatabaseApiImpl(this.database);

  final SchedulePaymentDatabase database;
  @override
  Future<Unit> deleteSchedulePaymentByIdApi(String id) async {
    try {
      await database.database;
      await database.deleteSchedulePayment(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<SchedulePayment?> getSchedulePaymentByIdApi(String id) async {
    try {
      await database.database;
      final result = await database.getSchedulePaymentById(id);
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
  Future<List<SchedulePayment>> getSchedulePaymentsApi() async {
    try {
      await database.database;
      final result = await database.getAllSchedulePaymentsDb();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertSchedulePaymentApi(SchedulePayment schedulePayment) async {
    try {
      await database.database;
      await database.insertSchedulePayment(schedulePayment);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateSchedulePayment(
    SchedulePayment schedulePayment,
  ) async {
    try {
      await database.database;
      await database.updateSchedulePayment(schedulePayment);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
