import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth_event.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<AuthInitEvent>((event, emit) => _onAuthInitEvent(emit));
    on<AuthLoginWithGoogleEvent>((event, emit) => _onAuthLoginEvent(emit));
    on<AuthSuccessEvent>((event, emit) => _onAuthSuccessEvent(emit));
    on<AuthFailedEvent>((event, emit) => _onAuthFailedEvent(emit));
  }

  ///
  /// On AuthInitEvent
  ///
  void _onAuthInitEvent(Emitter<AuthState> emit) {
    try {
      final isSignedIn = service.isSignedIn();
      if (isSignedIn) {
        final currentUser = service.getUser();
        emit(_userToState(currentUser));
      } else {
        emit(AuthFailedState());
      }
    } catch (_) {
      emit(AuthErrorState());
    }
  }

  ///
  /// On AuthLoginWithGoogleEvent
  ///
  void _onAuthLoginEvent(Emitter<AuthState> emit) async {
    try {
      await service.signInWithGoogle();
      final isSignedIn = service.isSignedIn();
      if (isSignedIn) {
        final currentUser = service.getUser();
        emit(_userToState(currentUser));
      } else {
        emit(AuthFailedState());
      }
    } catch (_) {
      emit(AuthErrorState());
    }
  }

  ///
  /// On AuthSuccessEvent
  ///
  void _onAuthSuccessEvent(Emitter<AuthState> emit) {
    final currentUser = service.getUser();
    emit(_userToState(currentUser));
  }

  ///
  /// On AuthFailedEvent
  ///
  void _onAuthFailedEvent(Emitter<AuthState> emit) {
    emit(AuthFailedState());
    service.signOut();
  }

  AuthState _userToState(final currentUser) {
    if (currentUser != null) {
      return AuthSuccessState(user: currentUser);
    } else {
      return AuthErrorState();
    }
  }

  AuthService get service => Modular.get<AuthService>();
}
