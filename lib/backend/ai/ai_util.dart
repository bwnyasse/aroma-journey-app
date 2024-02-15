import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiUtil {
  static const info = 'Gemini Pro';

  /// Generates text from a prompt
  static Future<String> generateText({
    required String exampleInput1,
    required String exampleOutput1,
    required String exampleInput2,
    required String exampleOutput2,
    required String exampleInput3,
    required String exampleOutput3,
    required String input,
  }) async {
    //
    const aiModel = 'gemini-pro';

    /// The API key is stored in the local .env file. Create one if you want to run
    /// this example or replace this apiKey with your own.
    ///
    /// DO NOT PUBLICLY SHARE YOUR API KEY.
    /// .env file should have a line that looks like this:
    ///
    /// GENERATIVE_AI_API_KEY=<GOOGLE_GENERATIVE_AI_API_KEY>
    ///
    final apiKey = dotenv.env['GENERATIVE_AI_API_KEY']!;

    // Construct the prompt string with input examples ( few shot prompt technique)
    String prompt = '''input: $exampleInput1
    output: $exampleOutput1
    
    input: $exampleInput2
    output: $exampleOutput2
    
    input: $exampleInput3
    output: $exampleOutput3
    
    input: $input
    output:''';

    final content = [Content.text(prompt)];

    final model = GenerativeModel(
      model: aiModel,
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
      generationConfig: GenerationConfig(
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
      ),
    );

    // Call the  API to generate text

    final GenerateContentResponse response =
        await model.generateContent(content);

    return response.text ?? '';
  }
}
