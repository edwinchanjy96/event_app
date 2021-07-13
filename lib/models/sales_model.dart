import 'package:event_app/config/util.dart';

class SalesModel {
  Public? public;
  List<Presales>? presales;

  SalesModel({this.public, this.presales});

  factory SalesModel.fromJson(Map json) {
    return SalesModel(
        public: json['public'] == null ? null : Public.fromJson(json['public']),
        presales: json['presales'] == null ? null : Presales.retrievePresalesList(json['presales']));
  }
}

class Public {
  bool startTBD;
  bool startTBA;
  String startDateTime;
  String endDateTime;

  Public(
      {required this.startTBD,
      required this.startTBA,
      required this.startDateTime,
      required this.endDateTime});

  factory Public.fromJson(Map json) {
    String formattedStartDateTime = '';
    String formattedEndDateTime = '';

    if(json['startDateTime'] != null)
    formattedStartDateTime =  Util.dateTimeFormatter(json['startDateTime']);
    if(json['endDateTime'] != null)
    formattedEndDateTime =  Util.dateTimeFormatter(json['endDateTime']);
    return Public(
        startTBD: json['startTBD'],
        startTBA: json['startTBA'],
        startDateTime: formattedStartDateTime,
        endDateTime: formattedEndDateTime);
  }
}

class Presales {
  String startDateTime;
  String endDateTime;
  String name;
  String? description;
  String? url;
  bool isExpanded;

  Presales(
      {required this.startDateTime,
      required this.endDateTime,
      required this.name,
      required this.description,
      required this.url,
      required this.isExpanded
      });

  factory Presales.fromJson(Map json) {
    String formattedStartDateTime = '';
    String formattedEndDateTime = '';

    if(json['startDateTime'] != null)
      formattedStartDateTime = Util.dateTimeFormatter(json['startDateTime']);
    if(json['endDateTime'] != null)
      formattedEndDateTime = Util.dateTimeFormatter(json['endDateTime']);

    return Presales(
        startDateTime: formattedStartDateTime,
        endDateTime: formattedEndDateTime,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        url: json['url'] ?? '',
        isExpanded: false
    );
  }

  static List<Presales> retrievePresalesList(List presale) {
    List<Presales> presalesList = [];
    presale.forEach((element) {
      presalesList.add(Presales.fromJson(element));
    });

    return presalesList;
  }
}
