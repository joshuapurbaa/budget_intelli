import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertMemberDb implements UseCase<Unit, Member> {
  InsertMemberDb(this.repository);
  final MemberDbRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Member params) async {
    return repository.insertMember(params);
  }
}
