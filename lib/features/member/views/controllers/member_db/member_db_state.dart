part of 'member_db_bloc.dart';

final class MemberDbState extends Equatable {
  const MemberDbState({
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.members = const <Member>[],
  });

  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  final List<Member> members;

  @override
  List<Object> get props => [
        insertSuccess,
        updateSuccess,
        deleteSuccess,
        members,
      ];
}
