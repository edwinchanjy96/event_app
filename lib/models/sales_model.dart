import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

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
    String formattedStartDateTime = Jiffy(DateTime.parse(json['startDateTime']).toLocal().toString()).format('yyyy-MM-dd HH:mm');
    String formattedEndDateTime = Jiffy(DateTime.parse(json['endDateTime']).toLocal().toString()).format('yyyy-MM-dd HH:mm');
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

  Presales(
      {required this.startDateTime,
      required this.endDateTime,
      required this.name,
      required this.description,
      required this.url});

  factory Presales.fromJson(Map json) {
    return Presales(
        startDateTime: json['startDateTime'],
        endDateTime: json['endDateTime'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        url: json['url'] ?? '');
  }

  static List<Presales> retrievePresalesList(List presale) {
    List<Presales> presalesList = [];
    presale.forEach((element) {
      presalesList.add(Presales.fromJson(element));
    });

    return presalesList;
  }
}
