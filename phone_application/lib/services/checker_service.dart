import 'package:get/utils.dart';

enum DataStatus { unknown, overdue, quitOverdue, noOverdue }

class CheckerService {
  DataStatus isFluorographyOverdue(String? date) {
    if (date == null || date == 'Нет даты' || date.isEmpty) {
      return DataStatus.unknown;
    }

    DateTime? dateTime;
    try {
      if (date.contains('.')) {
        // Обработка формата dd.mm.yyyy
        final parts = date.split('.');
        if (parts.length == 3) {
          dateTime = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } else {
        // Попытка стандартного парсинга ISO (yyyy-MM-dd)
        dateTime = DateTime.tryParse(date);
      }
    } catch (e) {
      return DataStatus.unknown;
    }

    if (dateTime == null) {
      return DataStatus.unknown;
    }

    final now = DateTime.now();
    final validUntilYear = dateTime.add(const Duration(days: 365));
    final validUntilHalfYear = dateTime.add(const Duration(days: 300));

    if (now.isAfter(validUntilYear)) {
      return DataStatus.overdue;
    } else if (now.isAfter(validUntilHalfYear)) {
      return DataStatus.quitOverdue;
    }
    return DataStatus.noOverdue;
  }
}
