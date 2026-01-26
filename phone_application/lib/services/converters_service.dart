import 'dart:math';

import 'package:get/get.dart';

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
    } else {
      userRole = 'undefined';
    }
    return userRole;
  }

  String convertDatePicker(DateTime date){
    String rawDateString = date.toString();
    String dateString = rawDateString.split(' ')[0];
    return dateString;
  }


  String formatFluraDate(String? date) {
    if (date == null) {
      return 'Нет даты';
    }
    if(date.toLowerCase() == 'null'){
      return 'Нет даты';
    }
    if (date is int){
      return 'Дата int';
    }
    try{
      final dateTime = DateTime.parse(date);
      final String convertedTime =
          '${dateTime.day.toString().padLeft(2, '0')}'
          '.${dateTime.month.toString().padLeft(2, '0')}'
          '.${dateTime.year}';
      return convertedTime;
    } catch (e){
      //print('Неверный формат даты $date');
      return 'Нет даты';
    }
  }
}
