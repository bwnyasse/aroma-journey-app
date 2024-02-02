import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<AuthInitEvent>((event, emit) => _onAuthInitEvent(emit));
    on<AuthLoginWithGoogleEvent>(
        (event, emit) => _onAuthLoginEvent(emit, false));
    on<AuthLoginWithAnonymousEvent>(
        (event, emit) => _onAuthLoginEvent(emit, true));
    on<AuthSuccessEvent>((event, emit) => _onAuthSuccessEvent(emit));
    on<AuthFailedEvent>((event, emit) => _onAuthFailedEvent(emit));
    on<AuthLoadingEvent>((event, emit) => emit(AuthLoadingState()));
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
      print("1");
      emit(AuthErrorState());
    }
  }

  ///
  /// On AuthLoginWithGoogleEvent
  ///
  void _onAuthLoginEvent(Emitter<AuthState> emit, bool anonymous) async {
    try {
      anonymous
          ? await service.signInAnoymously()
          : await service.signInWithGoogle();
      final isSignedIn = service.isSignedIn();
      if (isSignedIn) {
        final currentUser = service.getUser();
        emit(_userToState(currentUser));
      } else {
        emit(AuthFailedState());
      }
    } catch (e) {
      print("2");
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
      print("3");
      return AuthErrorState();
    }
  }

  AuthService get service => Modular.get<AuthService>();
}
