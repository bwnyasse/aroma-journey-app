import 'package:aroma_journey/bloc/auth/auth_bloc.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();
AuthService get authService => Modular.get<AuthService>();

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(authService.getUser().displayName),
        Text(authService.getUser().email),
        FFButtonWidget(
          onPressed: () async {
            authService.signOut();
          },
          text: 'Test Log out',
          options: FFButtonOptions(
            width: 240.0,
            height: 60.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
            elevation: 2.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ],
    );
  }
}
