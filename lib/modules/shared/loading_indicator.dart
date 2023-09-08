import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class LoadinIndicator extends StatelessWidget {
  const LoadinIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
              'Loading from PaLM API ...'), // Text widget for your loading text
          const SizedBox(height: 16),
          SizedBox(
            width: 200.0,
            height: 5.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
