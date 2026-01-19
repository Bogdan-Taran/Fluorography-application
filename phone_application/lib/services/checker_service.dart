import 'package:get/utils.dart';

class CheckerService {
  bool isFluorographyOverdue(String? date){
    final dateTime = DateTime.parse(date ?? '');
    if(date == null) return true;

    final validUntil = dateTime.add(Duration(days: 365));
    return DateTime.now().isAfter(validUntil);
  }
}