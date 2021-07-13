import 'package:event_app/models/classification_model.dart';

class ProductModel {
  final String name;
  final String id;
  final String url;
  final String type;
  final ClassificationModel classification;
  bool isExpanded;
  
  ProductModel({required this.name, required this.id, required this.url, required this.type, required this.classification, required this.isExpanded});
  
  factory ProductModel.fromJson (Map json){
    return ProductModel(
      name: json['name'],
      id: json['id'],
      url: json['url'],
      type: json['type'],
      classification: ClassificationModel.fromJson(json['classifications'].first),
      isExpanded: false
    );
  }

  static List<ProductModel> retrieveProductsList (List products) {
    List<ProductModel> productsList = [];
    products.forEach((element) {
      productsList.add(ProductModel.fromJson(element));
    });
    return productsList;
  }
}