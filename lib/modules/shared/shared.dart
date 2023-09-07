import 'dart:math';

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
  'blurOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      ShakeEffect(
        curve: Curves.easeInOut,
        delay: 80.ms,
        duration: 1000.ms,
        hz: 5,
        offset: const Offset(0, 0),
        rotation: 0.105,
      ),
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 80.ms,
        duration: 1000.ms,
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
      ),
    ],
  ),
  'containerOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 300.ms,
        begin: const Offset(0, 100),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'containerOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: const Offset(0.6, 0.6),
        end: const Offset(1, 1),
      ),
    ],
  ),
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

String getRandomCoffeeType() {
  final List<String> coffeeTypes = [
    'Caramel Capuccino',
    'Vanilla Capuccino',
    'Classic Capuccino',
    'Mocha Cold Brew',
    'Vanilla Cold Brew',
    'Classic Cold Brew',
    'Double Shot Expresso',
    'Expresso Macchiato',
    'Classic Expresso',
  ];
  final random = Random();
  final randomIndex = random.nextInt(coffeeTypes.length);
  return coffeeTypes[randomIndex];
}

String getRandomCategory() {
  final List<String> coffeeTypes = [
    'Capuccino',
    'Cold Brew',
    'Expresso',
  ];
  final random = Random();
  final randomIndex = random.nextInt(coffeeTypes.length);
  return coffeeTypes[randomIndex];
}
