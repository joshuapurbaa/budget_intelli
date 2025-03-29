
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_session_state.dart';

class UserSessionCubit extends Cubit<UserSessionState> {
  UserSessionCubit() : super(UserSessionInitial());
}
