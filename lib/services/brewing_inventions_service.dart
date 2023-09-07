import 'dart:convert';

import 'package:aroma_journey/backend/palm/palm_util.dart';
import 'package:aroma_journey/modules/shared/shared.dart' as shared;

class BrewingInventionModel {
  final String categoryName;
  final String name;
  final String info;
  final String offerDescription;
  final bool isOffer;

  BrewingInventionModel({
    required this.categoryName,
    required this.name,
    required this.info,
    required this.offerDescription,
    required this.isOffer,
  });

  factory BrewingInventionModel.fromJson(Map<String, dynamic> json) {
    return BrewingInventionModel(
      categoryName: json['category_name'] ?? '',
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      offerDescription: json['offer_description'] ?? '',
      isOffer: true,
    );
  }
}

const String exampleInput1 =
    '''input: Create a new coffee creation in the "Cold Brew" category. Provide its details in JSON format. { "category_name": "Cold Brew", "name": "", "info": "", "offer_description": "" }''';
const String exampleOutput1 =
    '''{"category_name":"Cold Brew","name":"Tropical Chill","info":"Tropical Chill is a refreshing cold brew coffee with a tropical twist. It's crafted using the finest cold brew method, resulting in a smooth and naturally sweet coffee base. Infused with hints of coconut and a touch of pineapple essence, this unique creation captures the essence of a beachside getaway in every sip.","offer_description":"Indulge in the paradise of flavor with Tropical Chill. Experience the soothing coolness of cold brew coffee combined with the exotic allure of the tropics. This coffee creation promises a delightful escape from the ordinary, making it the perfect companion for those seeking a refreshing and revitalizing coffee experience."}''';

const String exampleInput2 =
    '''input: Create a new coffee creation in the "Cappuccino" category. Provide its details in JSON format. { "category_name": "Cappuccino", "name": "", "info": "", "offer_description": "" }''';
const String exampleOutput2 =
    '''{"category_name":"Cappuccino","name":"Velvet Bliss","info":"Velvet Bliss is an exquisite cappuccino creation that redefines indulgence. It starts with a rich, double-shot espresso base, meticulously blended with velvety steamed milk. The magic happens with a drizzle of artisanal dark chocolate and a whisper of Madagascar vanilla, culminating in a coffee experience that's pure luxury.","offer_description":"Elevate your senses with Velvet Bliss, where every sip is an invitation to luxury. This cappuccino masterpiece combines the boldness of espresso with the silkiness of steamed milk, kissed by the sweetness of dark chocolate and vanilla. It's the epitome of coffee opulence, crafted to delight the most discerning coffee enthusiasts."}''';

const String exampleInput3 =
    '''input: Create a new coffee creation in the "Espresso" category. Provide its details in JSON format. { "category_name": "Espresso", "name": "", "info": "", "offer_description": "" }''';
const String exampleOutput3 =
    '''{"category_name":"Espresso","name":"Midnight Elegance","info":"Midnight Elegance is a bold and robust espresso that combines the intensity of dark roasted beans with a hint of smoky aroma. Its unique profile is characterized by a velvety texture and a rich, full-bodied flavor. This espresso boasts a satisfyingly long-lasting crema, making it perfect for those who savor the essence of strong, aromatic coffee.","offer_description":"Experience the allure of Midnight Elegance, where every sip is an indulgence in the dark artistry of espresso. Specially crafted for espresso aficionados, this coffee creation promises a journey into the depths of flavor. Discover a world of boldness and complexity with each cup."}''';

class BrewingInventionService {
  Future<List<BrewingInventionModel>> generateInventions() async {
    final List<String> randomCategory = List.generate(
      2,
      (_) => shared.getRandomCategory(),
    );

    final List<BrewingInventionModel> records = [];

    for (final category in randomCategory) {
      final String output = await _generativeBrewinginventions(category);
      final model = BrewingInventionModel.fromJson(json.decode(output));
      records.add(model);
    }

    return records;
  }

  Future<String> _generativeBrewinginventions(String category) async =>
      PaLMUtil.generateTextFormPaLM(
        exampleInput1: exampleInput1,
        exampleOutput1: exampleOutput1,
        exampleInput2: exampleInput2,
        exampleOutput2: exampleOutput2,
        exampleInput3: exampleInput3,
        exampleOutput3: exampleOutput3,
        input:
            """Create a new coffee creation in the "$category" category. Provide its details in JSON format. { "category_name": "$category", "name": "", "info": "", "offer_description": "" }""",
      );
}
