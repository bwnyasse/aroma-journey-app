import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/modules/quizz/quizz_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';

QuizzService get quizzService => Modular.get<QuizzService>();

bool isQuizzSubmit = false;

class QuizQuestion {
  final String question;
  bool? userChoice; // Added property to store user choice
  final bool correct;

  QuizQuestion({
    required this.question,
    required this.correct,
  });

  @override
  String toString() {
    return 'Question: $question\nCorrect Answer: $correct';
  }
}

class QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final ValueChanged<bool> onChoiceChanged;
  const QuestionCard(this.question, this.onChoiceChanged);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              question.question,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  label: 'True',
                  isSelected: question.userChoice != null &&
                      question.userChoice == true,
                  onTap: () {
                    onChoiceChanged(true);
                  },
                ),
                const SizedBox(width: 20),
                ChoiceButton(
                  label: 'False',
                  isSelected: question.userChoice != null &&
                      question.userChoice == false,
                  onTap: () {
                    onChoiceChanged(false);
                  },
                ),
                const SizedBox(width: 10),
                if (isQuizzSubmit &&
                    question.userChoice != question.correct) ...[
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const ChoiceButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: onTap,
      options: FFButtonOptions(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.grey,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
        elevation: 2.0,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      text: label,
    );
  }
}

class QuizzPage extends StatefulWidget {
  static const String routeKey = 'quizz';
  const QuizzPage({super.key});

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<QuizQuestion> questions = [];
  String resultStatus = '';

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1190.ms,
          begin: const Offset(0, -34),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1190.ms,
          begin: const Offset(0, 51),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    quizzService.generateRandomQuizQuestions().then((value) {
      setState(() {
        print(value);
        questions = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Generated code for this Text Widget...
                            Expanded(
                              child: Text(
                                "Today's Quiz",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Generated code for this Text Widget...
                            Expanded(
                              child: Text(
                                resultStatus,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (questions.isEmpty)
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5.0,
                        ),
                      ),
                    ),
                  if (questions.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Builder(
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (var question in questions)
                                  QuestionCard(question, (choice) {
                                    setState(() {
                                      question.userChoice = choice;
                                    });
                                  }),
                                const SizedBox(height: 10),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: () {
                                          // Reset user choices
                                          setState(() {
                                            for (var question in questions) {
                                              question.userChoice = null;
                                            }
                                            resultStatus = '';
                                            isQuizzSubmit = false;
                                          });
                                        },
                                        options: FFButtonOptions(
                                          width: 120.0,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        text: 'Reset',
                                        icon: const Icon(
                                          Icons.restart_alt_outlined,
                                          size: 24.0,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      FFButtonWidget(
                                        onPressed: () {
                                          // Evaluate the quiz and display result
                                          int correctAnswers = 0;
                                          for (var question in questions) {
                                            if (question.userChoice ==
                                                question.correct) {
                                              // Evaluate user choice, you can adjust this based on your evaluation logic
                                              correctAnswers++;
                                            }
                                          }
                                          setState(() {
                                            resultStatus =
                                                'You got $correctAnswers out of ${questions.length} questions correct.';
                                            isQuizzSubmit = true;
                                          });
                                        },
                                        options: FFButtonOptions(
                                          width: 120.0,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        text: 'Submit',
                                        icon: const Icon(
                                          Icons.send_outlined,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
