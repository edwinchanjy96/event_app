import 'package:geolocator/geolocator.dart' as geo;

class LocationModel {
  final String id;
  final String name;
  final String type;
  final LocationCityModel? city;
  final LocationStateModel? state;
  final LocationCountryModel? country;
  final LocationAddressModel address;
  final geo.Position position;
  final String postalCode;
  final BoxOfficeInfoModel? boxOfficeInfo;
  final String? accessibleSeatingDetail;
  final GeneralInfoModel? generalInfo;

  LocationModel(
      {required this.id,
        required this.name,
        required this.type,
        this.city,
        this.state,
        this.country,
        required this.address,
        required this.position,
        required this.postalCode,
        required this.boxOfficeInfo,
        required this.accessibleSeatingDetail,
        required this.generalInfo

          });

  factory LocationModel.fromJson(Map json) {
    return LocationModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        city: json['city'] == null ? null : LocationCityModel.fromJson(json['city']),
        state: json['state'] == null ? null : LocationStateModel.fromJson(json['state']),
        country: json['country'] == null ? null : LocationCountryModel.fromJson(json['country']),
        address: LocationAddressModel.fromJson(json['address']),
        position: geo.Position.fromMap({"latitude" : double.parse(json['location']['latitude']), "longitude" : double.parse(json['location']['longitude'])}),
        postalCode: json['postalCode'],
        boxOfficeInfo:  json['boxOfficeInfo'] == null ? null : BoxOfficeInfoModel.fromJson(json['boxOfficeInfo']),
        accessibleSeatingDetail: json['accessibleSeatingDetail'] ?? '',
        generalInfo: json['generalInfo'] == null ? null : GeneralInfoModel.fromJson(json['generalInfo'])
      );
  }
}

class LocationCityModel {
  String name;

  LocationCityModel({required this.name});

  factory LocationCityModel.fromJson(Map json) {
    return LocationCityModel(name: json['name']);
  }
}

class LocationStateModel {
  String name;
  String stateCode;

  LocationStateModel({required this.name, required this.stateCode});

  factory LocationStateModel.fromJson(Map json) {
    return LocationStateModel(name: json['name'], stateCode: json['stateCode']);
  }
}

class LocationCountryModel {
  String name;
  String countryCode;

  LocationCountryModel({required this.name, required this.countryCode});

  factory LocationCountryModel.fromJson(Map json) {
    return LocationCountryModel(name: json['name'], countryCode: json['countryCode']);
  }
}

class LocationAddressModel {
  String line1;

  LocationAddressModel({required this.line1});

  factory LocationAddressModel.fromJson(Map json) {
    return LocationAddressModel(line1: json['line1']);
  }
}

class LocationMarketModel {
  String id;
  String name;

  LocationMarketModel({required this.id, required this.name});

  factory LocationMarketModel.fromJson(Map json) {
    return LocationMarketModel(id: json['id'], name: json['name']);
  }
}

class BoxOfficeInfoModel {
  String? phoneNumberDetail;
  String? openHoursDetail;
  String? willCallDetail;

  BoxOfficeInfoModel({
    required this.phoneNumberDetail,
    required this.openHoursDetail,
    required this.willCallDetail
});

  factory BoxOfficeInfoModel.fromJson(Map json) {
    return BoxOfficeInfoModel(phoneNumberDetail: json['phoneNumberDetail'] ?? '', openHoursDetail: json['openHoursDetail'] ?? '', willCallDetail: json['willCallDetail'] ?? '');
  }
}

class GeneralInfoModel {
  String? generalRule;
  String? childRule;

  GeneralInfoModel({
    required this.generalRule,
    required this.childRule
  });

  factory GeneralInfoModel.fromJson(Map json) {
    return GeneralInfoModel(generalRule: json['generalRule'] ?? '', childRule: json['childRule'] ?? '');
  }
}
