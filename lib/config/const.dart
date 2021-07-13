import 'package:jiffy/jiffy.dart';

class Const {
  static const ticketPlaceholder = 'assets/placeholder/ticket_placeholder.jpeg';

//ticket status
  static const String onsale = 'onsale';
  static const String offsale = 'offsale';
  static const String canceled = 'canceled';
  static const String postponed = 'postponed';
  static const String rescheduled = 'rescheduled';

  static String dateTimeFormatter(String date){
    String formattedDate = Jiffy(DateTime.parse(date).toLocal().toString()).format('yyyy-MM-dd HH:mm');
    return formattedDate;
  }
}
