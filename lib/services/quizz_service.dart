import 'dart:math';

import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_language_api/google_generative_language_api.dart';

class QuizzServiceException implements Exception {
  final Object error;
  final String message;

  QuizzServiceException(this.message, this.error) {
    print(error);
  }
}

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
  /// The API key is stored in the local .env file. Create one if you want to run
  /// this example or replace this apiKey with your own.
  ///
  /// DO NOT PUBLICLY SHARE YOUR API KEY.
  /// .env file should have a line that looks like this:
  ///
  /// API_KEY=<PALM_API_KEY>
  late final String apiKey;

  final String textModel = 'models/text-bison-001';

  QuizzService() {
    apiKey = dotenv.env['PALM_API_KEY']!;
  }

  QuizQuestion _parseQuizQuestion(String input) {
    final String questionText = input.substring(15, input.indexOf('{')).trim();
    final bool correct = input.endsWith('{True}');

    return QuizQuestion(
      question: questionText,
      correct: correct,
    );
  }

  String _getRandomCoffeeType() {
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

  Future<List<QuizQuestion>> generateRandomQuizQuestions() async {
    final List<String> randomCoffeeTypes = List.generate(
      3,
      (_) => _getRandomCoffeeType(),
    );

    final List<QuizQuestion> quizQuestions = [];

    for (final coffeeType in randomCoffeeTypes) {
      final String output = await _generativeAIQuizzCoffeJourney(coffeeType);
      final QuizQuestion question = _parseQuizQuestion(output);
      quizQuestions.add(question);
    }

    return quizQuestions;
  }

  Future<String> _generativeAIQuizzCoffeJourney(String coffee) async {
    //  Prompt
    String promptString = '''input: $exampleInput1
    output: $exampleOutput1
    
    input: $exampleInput2
    output: $exampleOutput2
    
    input: $exampleInput3
    output: $exampleOutput3
    
    input: Could you generate a true or false question about $coffee for me? Please include the answer at the end within curly braces {}.;
    output:''';

    // Generate text.
    GenerateTextRequest textRequest = GenerateTextRequest(
        prompt: TextPrompt(text: promptString),
        // optional, 0.0 always uses the highest-probability result
        temperature: 0.7,
        // optional, how many candidate results to generate
        candidateCount: 1,
        // optional, number of most probable tokens to consider for generation
        topK: 40,
        // optional, for nucleus sampling decoding strategy
        topP: 0.95,
        // optional, maximum number of output tokens to generate
        maxOutputTokens: 1024,
        // optional, sequences at which to stop model generation
        stopSequences: [],
        // optional, safety settings
        safetySettings: const [
          SafetySetting(
              category: HarmCategory.derogatory,
              threshold: HarmBlockThreshold.lowAndAbove),
          SafetySetting(
              category: HarmCategory.toxicity,
              threshold: HarmBlockThreshold.lowAndAbove),
          SafetySetting(
              category: HarmCategory.violence,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.sexual,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.medical,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.dangerous,
              threshold: HarmBlockThreshold.mediumAndAbove),
        ]);
    final GeneratedText response = await GenerativeLanguageAPI.generateText(
      modelName: textModel,
      request: textRequest,
      apiKey: apiKey,
    );
    if (response.candidates.isNotEmpty) {
      TextCompletion candidate = response.candidates.first;
      return candidate.output;
    }
    return '';
  }
}
