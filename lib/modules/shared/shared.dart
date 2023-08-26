import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final animationsMap = {
  'rowOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1120.ms,
        begin: const Offset(-46.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'textOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1120.ms,
        begin: const Offset(-46.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'rowOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 720.ms,
        begin: const Offset(0.0, -27.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'choiceChipsOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeIn,
        delay: 0.ms,
        duration: 1040.ms,
        begin: 0.0,
        end: 1.0,
      ),
    ],
  ),
  'rowOnPageLoadAnimation3': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1080.ms,
        begin: const Offset(41.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'textOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1230.ms,
        begin: const Offset(-44.99999999999999, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
};
