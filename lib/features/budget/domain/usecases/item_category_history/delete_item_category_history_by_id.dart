import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryHistoryById implements UseCase<Unit, String> {
  DeleteItemCategoryHistoryById(this.repository);

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteItemCategoryHistoryById(id: id);
  }
}
