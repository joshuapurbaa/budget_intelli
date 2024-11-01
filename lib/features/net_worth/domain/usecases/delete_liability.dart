import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteLiabilities implements UseCase<Unit, String> {

  DeleteLiabilities({
    required this.liabilitiesRepository,
  });
  final LiabilityRepository liabilitiesRepository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return liabilitiesRepository.deleteLiability(id);
  }
}
