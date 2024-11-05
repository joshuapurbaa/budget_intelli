import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateMemberDb implements UseCase<Unit, Member> {
  UpdateMemberDb(this.repository);
  final MemberDbRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Member params) async {
    return repository.updateMember(params);
  }
}
