part of 'user_session_cubit.dart';

sealed class UserSessionState extends Equatable {
  const UserSessionState();

  @override
  List<Object> get props => [];
}

final class UserSessionInitial extends UserSessionState {}
