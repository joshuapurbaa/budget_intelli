import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/liability_entity.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class InsertLiabilityUsecase implements UseCase<Unit, LiabilityEntity> {

  InsertLiabilityUsecase({
    required this.liabilitiesRepository,
  });
  final LiabilityRepository liabilitiesRepository;

  @override
  Future<Either<Failure, Unit>> call(LiabilityEntity liabilities) {
    return liabilitiesRepository.insertLiability(liabilities);
  }
}
