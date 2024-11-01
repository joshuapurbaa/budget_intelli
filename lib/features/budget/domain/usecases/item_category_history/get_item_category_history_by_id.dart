import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryHistoryById
    implements UseCase<ItemCategoryHistory, String> {
  GetItemCategoryHistoryById({
    required this.repository,
  });

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, ItemCategoryHistory>> call(String id) async {
    return repository.getItemCategoryHistoryById(id);
  }
}
