import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MemberDbRepository {
  Future<Either<Failure, Unit>> deleteMember(String id);
  Future<Either<Failure, Member?>> getMember(String id);
  Future<Either<Failure, List<Member>>> getAllMember();
  Future<Either<Failure, Unit>> insertMember(Member param);
  Future<Either<Failure, Unit>> updateMember(Member param);
}

class MemberDbRepositoryImpl implements MemberDbRepository {
  MemberDbRepositoryImpl(this.api);

  final MemberDbApi api;

  @override
  Future<Either<Failure, Unit>> deleteMember(String id) async {
    try {
      await api.deleteMember(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Member>>> getAllMember() async {
    try {
      final result = await api.getAllMember();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Member?>> getMember(String id) async {
    try {
      final result = await api.getMember(id);

      if (result != null) {
        return right(result);
      } else {
        return left(DatabaseFailure('DB Failure: No data found'));
      }
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertMember(Member param) async {
    try {
      await api.insertMember(param);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMember(Member param) async {
    try {
      await api.updateMember(param);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
