import 'dart:math';

import 'package:aroma_journey/backend/ai/ai_util.dart';
import 'package:aroma_journey/backend/palm/palm_util.dart';
import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:aroma_journey/modules/shared/shared.dart' as shared;

const String exampleInput1 =
    'Could you generate a true or false question about Classic Expression for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput1 =
    '''True or False: Classic Espresso is a coffee beverage made by combining equal parts espresso, steamed milk, and milk foam. {False}''';

const String exampleInput2 =
    'Could you generate a true or false question about Caramel Cappuccino for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput2 =
    '''True or False: Caramel Cappuccino is a coffee drink made with equal parts espresso, steamed milk, and milk foam, combined with the sweetness of caramel drizzle. {True}''';

const String exampleInput3 =
    'Could you generate a true or false question about Mocha Cold Brew for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput3 =
    '''True or False: Mocha Cold Brew is a chilled coffee beverage made by steeping coarsely ground coffee in cold water and then adding a touch of chocolate syrup or cocoa powder for a rich mocha flavor. {True}''';

class QuizzService {
  QuizQuestion _parseQuizQuestion(String input) {
    final String questionText = input.substring(15, input.indexOf('{')).trim();
    final bool correct = input.endsWith('{True}');

    return QuizQuestion(
      question: questionText,
      correct: correct,
    );
  }

  Future<List<QuizQuestion>> generateRandomQuizQuestions() async {
    final List<String> randomCoffeeTypes = List.generate(
      3,
      (_) => shared.getRandomCoffeeType(),
    );

    final List<QuizQuestion> quizQuestions = [];

    for (final coffeeType in randomCoffeeTypes) {
      final String output = await _generativeAIQuizzCoffeJourney(coffeeType);
      final QuizQuestion question = _parseQuizQuestion(output);
      quizQuestions.add(question);
    }

    return quizQuestions;
  }

  Future<String> _generativeAIQuizzCoffeJourney(String coffee) async =>
      AiUtil.generateText(
        exampleInput1: exampleInput1,
        exampleOutput1: exampleOutput1,
        exampleInput2: exampleInput2,
        exampleOutput2: exampleOutput2,
        exampleInput3: exampleInput3,
        exampleOutput3: exampleOutput3,
        input:
            "Could you generate a true or false question about $coffee for me? Please include the answer at the end within curly braces {}.",
      );
}
