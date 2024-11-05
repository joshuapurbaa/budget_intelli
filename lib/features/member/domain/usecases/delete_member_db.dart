import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteMemberDb implements UseCase<Unit, String> {
  DeleteMemberDb(this.repository);
  final MemberDbRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return repository.deleteMember(id);
  }
}
