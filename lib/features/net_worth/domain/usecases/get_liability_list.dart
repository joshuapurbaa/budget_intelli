import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/liability_entity.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLiabilityListUsecase
    implements UseCase<List<LiabilityEntity>, NoParams> {

  GetLiabilityListUsecase(this.repository);
  final LiabilityRepository repository;

  @override
  Future<Either<Failure, List<LiabilityEntity>>> call(NoParams params) {
    return repository.getLiabilityList();
  }
}
