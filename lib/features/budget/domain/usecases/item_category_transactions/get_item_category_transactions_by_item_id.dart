import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryTransactionsByItemId
    implements UseCase<List<ItemCategoryTransaction>, String> {
  GetItemCategoryTransactionsByItemId({required this.repository});

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> call(String params) {
    return repository.getItemCategoryTransactionsByItemId(itemId: params);
  }
}
