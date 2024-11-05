import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAllMemberDb implements UseCase<List<Member>, NoParams> {
  GetAllMemberDb(this.repository);
  final MemberDbRepository repository;

  @override
  Future<Either<Failure, List<Member>>> call(NoParams params) async {
    return repository.getAllMember();
  }
}
