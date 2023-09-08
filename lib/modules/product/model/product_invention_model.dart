class ProductInventionModel {
  final String categoryName;
  final String name;
  final String info;
  final String offerDescription;
  final bool isOffer;

  ProductInventionModel({
    required this.categoryName,
    required this.name,
    required this.info,
    required this.offerDescription,
    required this.isOffer,
  });

  factory ProductInventionModel.fromJson(Map<String, dynamic> json) {
    return ProductInventionModel(
      categoryName: json['category_name'] ?? '',
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      offerDescription: json['offer_description'] ?? '',
      isOffer: true,
    );
  }
}