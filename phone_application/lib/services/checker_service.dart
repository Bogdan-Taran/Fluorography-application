import 'package:get/utils.dart';
enum DataStatus {unknown, overdue, quitOverdue, noOverdue}
class CheckerService {
  DataStatus isFluorographyOverdue(String? date){
    if (date == null || date == 'Нет даты') {
      return DataStatus.unknown;
    }
    final dateTime = DateTime.parse(date ?? '');
    final validUntilYear = dateTime.add(Duration(days: 365));
    final validUntilHalfYear = dateTime.add(Duration(days: 300));
    bool dateAfterHalfYear = DateTime.now().isAfter(validUntilHalfYear);
    bool dateAfterYear = DateTime.now().isAfter(validUntilYear);
    if(dateAfterYear){
      return DataStatus.overdue;
    }else if(dateAfterHalfYear){
      return DataStatus.quitOverdue;
    }
    return DataStatus.noOverdue;
  }
}
