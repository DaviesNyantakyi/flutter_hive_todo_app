import 'package:dart_date/dart_date.dart';

class FormalDates {
  static String dateDMY({required DateTime date}) {
    return date.format('dd MMMM y');
  }
}
