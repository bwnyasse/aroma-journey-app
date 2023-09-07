import 'package:aroma_journey/modules/auth/model/user.dart';

abstract class AuthState {}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

///
/// This is the state when user is authenticated and user object is created.
///
class AuthSuccessState extends AuthState {
  final CurrentUser user;

  // user is a required parameter to create the Authenticated state
  AuthSuccessState({required this.user});
}

///
/// state when user authentication fails
///
class AuthFailedState extends AuthState {}

///
/// state whe error occurs during the auth process
///
class AuthErrorState extends AuthState {}
