import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthService get authService => Modular.get<AuthService>();

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 500),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  imageUrl: authService.getUser().photoURL,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              // Generated code for this location Widget...
              /*Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.location_on,
                    color:
                        FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  Text(
                    'Porto Alegre, Brazil',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                  ),
                ],
              ),*/
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: FFButtonWidget(
                  onPressed: () async {
                    authService.signOut();
                  },
                  text: 'Logout',
                  options: FFButtonOptions(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  'Welcome, ${authService.getUser().displayName.split(' ')[0]}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
