import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_language_api/google_generative_language_api.dart';

class PaLMUtil {
  /// Generates text from a prompt using the PaLM 2.0 model.
  static Future<String> generateTextFormPaLM({
    required String exampleInput1,
    required String exampleOutput1,
    required String exampleInput2,
    required String exampleOutput2,
    required String exampleInput3,
    required String exampleOutput3,
    required String input,
  }) async {
    /// The API key is stored in the local .env file. Create one if you want to run
    /// this example or replace this apiKey with your own.
    ///
    /// DO NOT PUBLICLY SHARE YOUR API KEY.
    /// .env file should have a line that looks like this:
    ///
    /// API_KEY=<PALM_API_KEY>
    ///
    String apiKey = dotenv.env['PALM_API_KEY']!;

    // PaLM 2.0 model
    String textModel = 'models/text-bison-001';

    // Construct the prompt string with input examples
    String promptString = '''input: $exampleInput1
    output: $exampleOutput1
    
    input: $exampleInput2
    output: $exampleOutput2
    
    input: $exampleInput3
    output: $exampleOutput3
    
    input: $input
    output:''';

    // Configure the text generation request
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
          // Define safety settings to filter out harmful content
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

    // Call the PaLM API to generate text
    final GeneratedText response = await GenerativeLanguageAPI.generateText(
      modelName: textModel,
      request: textRequest,
      apiKey: apiKey,
    );

    // Extract and return the generated text
    if (response.candidates.isNotEmpty) {
      TextCompletion candidate = response.candidates.first;
      return candidate.output;
    }
    return '';
  }
}
