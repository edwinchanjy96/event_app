import 'package:jiffy/jiffy.dart';

class Util {
  static String dateTimeFormatter(String date){
    String formattedDate = Jiffy(DateTime.parse(date).toLocal().toString()).format('yyyy-MM-dd HH:mm');
    return formattedDate;
  }
}