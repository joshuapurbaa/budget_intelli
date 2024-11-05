import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MemberDbApi {
  Future<Unit> deleteMember(String id);
  Future<Member?> getMember(String id);
  Future<List<Member>> getAllMember();
  Future<Unit> insertMember(Member param);
  Future<Unit> updateMember(Member param);
}

class MemberDbApiImpl implements MemberDbApi {
  MemberDbApiImpl(this.db);
  final MemberDb db;

  @override
  Future<Unit> deleteMember(String id) async {
    try {
      await db.database;
      await db.deleteMember(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<Member>> getAllMember() async {
    try {
      await db.database;
      final result = await db.getAllMember();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Member?> getMember(String id) async {
    try {
      await db.database;
      final result = await db.getMember(id);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertMember(Member param) async {
    try {
      await db.database;
      await db.insertMember(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateMember(Member param) async {
    try {
      await db.database;
      await db.updateMember(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
