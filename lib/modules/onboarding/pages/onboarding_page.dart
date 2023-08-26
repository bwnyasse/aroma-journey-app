import 'package:aroma_journey/bloc/auth/auth_bloc.dart';
import 'package:aroma_journey/bloc/auth/auth_state.dart';
import 'package:aroma_journey/modules/onboarding/pages/login_widget.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      child: LoginWidget(scaffoldKey: scaffoldKey),
      listener: (context, state) {
        if (state is AuthFailedState) {
          AsukaSnackbar.warning("AuthFailedState").show();
        }
        if (state is AuthErrorState) {
          AsukaSnackbar.alert("AuthFailedState").show();
        }
        if (state is AuthSuccessState) {
          AsukaSnackbar.success("Welcome to Aroma").show();
        }
      },
    );
  }
}
