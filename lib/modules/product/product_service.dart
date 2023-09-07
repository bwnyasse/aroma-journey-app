import 'package:aroma_journey/backend/palm/palm_util.dart';


const String exampleInput1 =
    'Could you provide step-by-step instructions on how to brew a delicious Mocha Cold Brew ? The ouput must be in markdown format.';
const String exampleOutput1 =
    '''Here's a step-by-step guide to brewing a delightful Mocha Cold Brew:

1. **Gather Your Ingredients:**
   - Coarsely ground coffee beans
   - Cold, filtered water
   - Chocolate syrup
   - Milk (dairy or non-dairy)

2. **Coffee-to-Water Ratio:**
   - Use a 1:4 coffee-to-water ratio. For example, if you have 1 cup of coarsely ground coffee, use 4 cups of cold water.

3. **Combine Coffee and Water:**
   - In a large jar or pitcher, combine the coarsely ground coffee and cold water. Stir well to ensure even saturation.

4. **Steep Time:**
   - Cover the jar/pitcher and let the coffee steep in the refrigerator for about 12-24 hours. This slow steeping process extracts flavors without bitterness.

5. **Filtering:**
   - After steeping, use a fine-mesh strainer or a cold brew coffee maker to separate the liquid from the coffee grounds.

6. **Mix in Chocolate Syrup:**
   - To create the Mocha flavor, add a generous amount of chocolate syrup to the cold brew concentrate. Adjust the amount to your taste preference.

7. **Add Milk:**
   - Fill a glass with ice and pour in the cold brew concentrate, leaving some space at the top. Top off with milk, whether it's dairy or your preferred non-dairy option.

8. **Stir and Enjoy:**
   - Give the Mocha Cold Brew a good stir to combine all the flavors. Sip and savor the harmonious blend of coffee and chocolate, enhanced by the cold and refreshing nature of the brew.

9. **Optional Garnish:**
   - If you like, you can add whipped cream, a drizzle of extra chocolate syrup, or a sprinkle of cocoa powder as a finishing touch.

10. **Experiment and Customize:**
   - Feel free to experiment with the coffee-to-water ratio and chocolate syrup amount to create your perfect Mocha Cold Brew. Enjoy!"

Remember, the key to a delicious Mocha Cold Brew is finding the right balance between coffee, chocolate, and milk. Enjoy your brewing adventure!''';

const String exampleInput2 =
    'Could you describe the flavor profile of Classic Espresso, highlighting its aroma, primary taste notes, and any undertones that coffee enthusiasts can expect to savor? The ouput must be in markdown format.';
const String exampleOutput2 =
    '''Let's delve into the captivating flavor journey of Classic Espresso:

**Aroma:**
As you bring a cup of Classic Espresso to your nose, you'll be greeted by a rich and invigorating aroma. The scent is deep and earthy, with prominent notes of roasted coffee beans and a hint of bittersweet cocoa. The aroma sets the stage for the bold and complex taste that's about to unfold.

**Primary Taste Notes:**
Upon your first sip, Classic Espresso envelops your palate with a full-bodied and intense flavor. The primary taste notes are characterized by the robust essence of dark chocolate and a pleasantly balanced bitterness reminiscent of unsweetened cocoa. These notes provide a strong foundation that's quintessential to a classic espresso experience. You'll also notice a subtle nutty undertone that adds a layer of depth to the flavor.

**Undertones:**
As you explore the depths of Classic Espresso's flavor profile, you'll discover delicate undertones that enhance the overall taste. A fleeting hint of toasted almonds dances on the edges of your palate, complementing the chocolate and adding a touch of sweetness. These undertones offer a gentle contrast to the boldness of the coffee, creating a harmonious and satisfying balance.

**Finish:**
The journey concludes with a smooth and lingering finish. The bitterness of the espresso is well-balanced, leaving a refined and memorable aftertaste that beckons you to savor every sip. Classic Espresso's finish is both invigorating and comforting, leaving you with a sense of satisfaction that lingers pleasantly.

In summary, Classic Espresso is a symphony of flavors that intertwine to create a remarkable experience. From the deep and earthy aroma to the interplay of dark chocolate, nutty undertones, and a balanced finish, this espresso embodies the essence of traditional craftsmanship. Whether enjoyed on its own or as the foundation for other coffee creations, Classic Espresso is a timeless journey of taste that coffee enthusiasts will thoroughly enjoy.
''';

const String exampleInput3 =
    '''Could you provide insights into the potential health effects of incorporating Vanilla Cappuccino into one's routine, including considerations related to ingredients and nutritional aspects?''';
const String exampleOutput3 =
    '''Could you provide insights into the potential health effects of incorporating Vanilla Cappuccino into one's routine, including considerations related to ingredients and nutritional aspects?
output: Let's explore the potential health effects and considerations when incorporating Vanilla Cappuccino into your routine:

**Ingredients and Nutritional Aspects:**
Vanilla Cappuccino is a delightful fusion of espresso, steamed milk, and a touch of sweet vanilla flavor. The nutritional profile can vary based on factors such as the type of milk used (dairy or non-dairy), the amount of vanilla syrup, and whether any additional toppings are added.

**Moderation and Sugar Content:**
It's important to be mindful of the sugar content in Vanilla Cappuccino, especially if it includes flavored syrups. While the vanilla syrup adds a pleasant sweetness, it can contribute to the overall sugar intake. Opting for sugar-free or reduced-sugar syrups can be a way to enjoy the flavors without excess sugar.

**Balancing Calories:**
Vanilla Cappuccino, like any coffee-based beverage, contributes to your daily caloric intake. The addition of milk and syrups can increase the calorie count. If you're mindful of your calorie consumption, you might consider choosing lower-fat milk options or smaller serving sizes.

**Caffeine Content:**
Espresso-based drinks, including Vanilla Cappuccino, contain caffeine. While caffeine can provide an energy boost and enhance alertness, it's advisable to be aware of your overall caffeine intake. Some individuals are more sensitive to caffeine's effects, so adjusting your consumption based on your preferences is a good practice.

**Balanced Diet and Enjoyment:**
Incorporating Vanilla Cappuccino into your routine can certainly be a delightful treat. Enjoyment is a key aspect of a balanced approach to nutrition. If you're mindful of the ingredients and portion sizes, Vanilla Cappuccino can be a part of your overall diet without causing concerns.

**Personalized Choices:**
Ultimately, the health effects of enjoying Vanilla Cappuccino depend on your individual dietary goals, preferences, and lifestyle. If you're looking to reduce sugar or calories, you might explore alternative milk options or adjust the sweetness level. For those who appreciate the occasional indulgence, Vanilla Cappuccino can be a rewarding and satisfying choice.

In summary, Vanilla Cappuccino can be a delightful addition to your routine when enjoyed mindfully. It's advisable to consider factors such as sugar content, caloric intake, and caffeine sensitivity. Making informed choices based on your own health goals will help you savor this beverage in a way that aligns with your preferences and well-being.
''';

class ProductService {
  Future<Map<String, String>> multiGeneration(String coffee) {
    return Future.wait([
      _generativeAIPromptCoffeJourney(
          "Could you provide step-by-step instructions on how to brew a delicious $coffee ? The ouput must be in markdown format."),
      _generativeAIPromptCoffeJourney(
          "Could you describe the flavor profile of $coffee, highlighting its aroma, primary taste notes, and any undertones that coffee enthusiasts can expect to savor? The ouput must be in markdown format."),
      _generativeAIPromptCoffeJourney(
          "Could you provide insights into the potential health effects of incorporating $coffee into one's routine, including considerations related to ingredients and nutritional aspects?"),
    ]).then((value) => {
          'Brewing': value[0],
          'Taste': value[1],
          'Health': value[2],
        });
  }

  Future<String> _generativeAIPromptCoffeJourney(String input) async =>
      PaLMUtil.generateTextFormPaLM(
        exampleInput1: exampleInput1,
        exampleOutput1: exampleOutput1,
        exampleInput2: exampleInput2,
        exampleOutput2: exampleOutput2,
        exampleInput3: exampleInput3,
        exampleOutput3: exampleOutput3,
        input: input,
      );
}
