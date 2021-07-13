import 'package:event_app/models/classification_model.dart';
import 'package:event_app/models/external_links_model.dart';
import 'package:event_app/models/image_model.dart';

class AttractionModel {
  final String name;
  final String type;
  final String id;
  final String url;
  final ExternalLinksModel? externalLinks;
  final List<String>? aliases;
  final List<ImageModel> images;
  final ClassificationModel classifications;

  AttractionModel(
      {required this.name,
      required this.type,
      required this.id,
      required this.url,
      this.externalLinks,
      this.aliases,
      required this.images,
      required this.classifications});

  factory AttractionModel.fromJson(Map json) {
    return AttractionModel(
        name: json['name'],
        type: json['type'],
        id: json['id'],
        url: json['url'],
        externalLinks: json['externalLinks'] == null
            ? null
            : ExternalLinksModel.fromJson(json['externalLinks']),
        aliases: json['aliases'] == null ? [] : json['aliases'].cast<String>(),
        images: ImageModel.retrieveTicketImages(json['images']),
        classifications: ClassificationModel.fromJson(json['classifications'].first));
  }

  static List<AttractionModel> retrieveAttractionsList (List attractions) {
    List<AttractionModel> attractionsList = [];
    attractions.forEach((element) {
      AttractionModel.fromJson(element);
    });
    return attractionsList;
  }
}
