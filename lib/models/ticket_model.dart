import 'package:event_app/config/util.dart';
import 'package:event_app/models/attraction_model.dart';
import 'package:event_app/models/classification_model.dart';
import 'package:event_app/models/image_model.dart';
import 'package:event_app/models/location_model.dart';
import 'package:event_app/models/product_model.dart';
import 'package:event_app/models/promoter_model.dart';
import 'package:event_app/models/sales_model.dart';

class TicketModel {
  final String id;
  final String name;
  final String url;
  final SalesModel sales;
  final DateModel date;
  final ClassificationModel? classifications;
  final LocationModel? location;
  final List<AttractionModel>? attractions;
  final String info;
  final String pleaseNote;
  final List<ImageModel> ticketImages;
  final PriceRangesModel? priceRange;
  final PromoterModel? promoter;
  final List<PromoterModel>? promoters;
  final List<ProductModel>? products;
  final SeatMapModel? seatMap;
  final TicketLimitModel? ticketLimit;
  final AccessibilityModel? accessibility;
  final AgeRestrictionsModel? ageRestrictions;

  TicketModel(
      {required this.id,
      required this.name,
      required this.url,
      required this.ticketImages,
      required this.sales,
      required this.date,
      this.classifications,
      this.location,
      this.attractions,
      required this.info,
      required this.pleaseNote,
      this.priceRange,
      this.promoter,
      this.promoters,
      required this.products,
      this.seatMap,
      this.ticketLimit,
      this.accessibility,
      this.ageRestrictions});

  factory TicketModel.fromJson(Map json) {
    return TicketModel(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        ticketImages: ImageModel.retrieveTicketImages(json['images']),
        sales: SalesModel.fromJson(json['sales']),
        date: DateModel.fromJson(json['dates']),
        classifications: json['classifications'] == null ? null :
            ClassificationModel.fromJson(json['classifications'].first),
        location: json['_embedded'] == null
            ? null
            : json['_embedded']['venues'] == null ? null :  LocationModel.fromJson(json['_embedded']['venues'].first),
        attractions: json['_embedded'] == null
            ? null
            : json['_embedded']['attractions'] == null ? null : AttractionModel.retrieveAttractionsList(
                json['_embedded']['attractions']),
        info: json['info'] ?? '',
        pleaseNote: json['pleaseNote'] ?? '',
        priceRange: json['priceRanges'] == null
            ? null
            : PriceRangesModel.fromJson(json['priceRanges'].first),
        promoter: json['promoter'] == null
            ? null
            : PromoterModel.fromJson(json['promoter']),
        promoters: json['promoters'] == null
            ? null
            : PromoterModel.retrievePromotersList(json['promoters']),
        products: json['products'] == null
            ? []
            : ProductModel.retrieveProductsList(json['products']),
        seatMap: json['seatmap'] == null
            ? null
            : SeatMapModel.fromJson(json['seatmap']),
        ticketLimit: json['ticketLimit'] == null
            ? null
            : TicketLimitModel.fromJson(json['ticketLimit']),
        accessibility: json['accessibility'] == null
            ? null
            : AccessibilityModel.fromJson(json['accessibility']),
        ageRestrictions: json['ageRestrictions'] == null
            ? null
            : AgeRestrictionsModel.fromJson(json['ageRestrictions']));
  }
}

class DateModel {
  final DateStartModel start;
  final InitialStartDateModel? initialStartDate;
  final String timezone;
  final String status;

  DateModel({
    required this.start,
    this.initialStartDate,
    required this.timezone,
    required this.status,
  });

  factory DateModel.fromJson(Map json) {
    return DateModel(
        start: DateStartModel.fromJson(json['start']),
        initialStartDate: json['initialStartDate'] == null
            ? null
            : InitialStartDateModel.fromJson(json['initialStartDate']),
        timezone: json['timezone'],
        status: json['status']['code']);
  }
}

class DateStartModel {
  final String localDate;
  final String localTime;
  final String dateTime;
  final bool dateTBD;
  final bool dateTBA;
  final bool timeTBA;
  final bool noSpecificTime;

  DateStartModel({
    required this.localDate,
    required this.localTime,
    required this.dateTime,
    required this.dateTBD,
    required this.dateTBA,
    required this.timeTBA,
    required this.noSpecificTime,
  });

  factory DateStartModel.fromJson(Map json) {
    String formattedDateTime = '';

    if(json['dateTime'] != null)
      formattedDateTime = Util.dateTimeFormatter(json['dateTime']);

    return DateStartModel(
        localDate: json['localDate'],
        localTime: json['localTime'],
        dateTime: formattedDateTime,
        dateTBD: json['dateTBD'],
        dateTBA: json['dateTBA'],
        timeTBA: json['timeTBA'],
        noSpecificTime: json['noSpecificTime']);
  }
}

class InitialStartDateModel {
  final String localDate;
  final String localTime;
  final String dateTime;

  InitialStartDateModel(
      {required this.localDate,
      required this.localTime,
      required this.dateTime});

  factory InitialStartDateModel.fromJson(Map json) {
    return InitialStartDateModel(
        localDate: json['localDate'],
        localTime: json['localTime'],
        dateTime: json['dateTime']);
  }
}

class PriceRangesModel {
  String type;
  String currency;
  String minPrice;
  String maxPrice;

  PriceRangesModel(
      {required this.type,
      required this.currency,
      required this.minPrice,
      required this.maxPrice});

  factory PriceRangesModel.fromJson(Map json) {
    return PriceRangesModel(
        type: json['type'],
        currency: json['currency'],
        minPrice: json['min'].toStringAsFixed(2),
        maxPrice: json['max'].toStringAsFixed(2));
  }
}

class SeatMapModel {
  final String staticUrl;

  SeatMapModel({required this.staticUrl});

  factory SeatMapModel.fromJson(Map json) {
    return SeatMapModel(staticUrl: json['staticUrl']);
  }
}

class TicketLimitModel {
  final String info;

  TicketLimitModel({required this.info});

  factory TicketLimitModel.fromJson(Map json) {
    return TicketLimitModel(info: json['info']);
  }
}

class AccessibilityModel {
  final String info;
  final int ticketLimit;

  AccessibilityModel({required this.info, required this.ticketLimit});

  factory AccessibilityModel.fromJson(Map json) {
    return AccessibilityModel(
        info: json['info'] ?? '', ticketLimit: json['ticketLimit'] ?? 0);
  }
}

class AgeRestrictionsModel {
  final bool legalAgeEnforced;

  AgeRestrictionsModel({required this.legalAgeEnforced});

  factory AgeRestrictionsModel.fromJson(Map json) {
    return AgeRestrictionsModel(legalAgeEnforced: json['legalAgeEnforced']);
  }
}
