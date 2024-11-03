import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAllFinancialTransactionByMonthAndYearDb
    implements UseCase<List<FinancialTransaction>, MonthYearParams> {
  GetAllFinancialTransactionByMonthAndYearDb(this.repository);
  final FinancialTransactionRepository repository;

  @override
  Future<Either<Failure, List<FinancialTransaction>>> call(
    MonthYearParams params,
  ) async {
    return repository.getAllFinancialTransactionByMonthAndYear(
      params.month,
      params.year,
    );
  }
}

class MonthYearParams {
  MonthYearParams({
    required this.month,
    required this.year,
  });
  final String month;
  final String year;
}
