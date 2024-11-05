import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetMemberByIdDb implements UseCase<Member?, String> {
  GetMemberByIdDb(this.repository);
  final MemberDbRepository repository;

  @override
  Future<Either<Failure, Member?>> call(String id) async {
    return repository.getMember(id);
  }
}
