import 'dart:math';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:project_fluorography/styles.dart';

class ConverterServices {
  Future<String?> convertUserRoleFormListToNormalName(UserData) async {
    final List<int> userRoles = UserData.roles;
    final String userRole;
    if (userRoles.contains(1)) {
      userRole = 'medic';
    } else if (userRoles.contains(2)) {
      userRole = 'student';
    } else if (userRoles.contains(4)) {
      userRole = 'admin';
    } else if (userRoles.contains(5)) {
      userRole = 'curator';
    } else if (userRoles.contains(6)) {
      userRole = 'secretary';
    } else {
      userRole = 'undefined';
    }
    return userRole;
  }

  String convertDatePicker(DateTime date) {
    String rawDateString = date.toString();
    String dateString = rawDateString.split(' ')[0];
    return dateString;
  }

  String convertInputId(String uniqueId) {
    return uniqueId.split('_')[1];
  }

  String formatFluraDate(String? date) {
    if (date == null) {
      print('Нет даты');
      return 'Нет даты';
    }
    try {
      final dt = date;
      print('Есть дата: $dt');
      return dt;
    } catch (e) {
      return 'Catch - нет даты';
    }
  }

  String getStatusText(int statusId) {
    switch (statusId) {
      case 1:
        return 'В процессе';
      case 2:
        return 'Готова';
      case 3:
        return 'Дубликат';
      default:
        return 'Неизвестно';
    }
  }
  Color getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return AppStyle.yellowProcessColor;
        case 2:
        return AppStyle.statusReadyGreenColor;
      case 3:
        return AppStyle.redColorTag;
      default:
        return AppStyle.yellowProcessColor;
    }
  }
}
