import 'package:aroma_journey/bloc/auth/auth_bloc.dart';
import 'package:aroma_journey/modules/home/widgets/home_categories_widget.dart';
import 'package:aroma_journey/modules/home/widgets/home_header_widget.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: const SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          HomeHeaderWidget(),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HomeCategoriesWidget(),
                                ]),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
