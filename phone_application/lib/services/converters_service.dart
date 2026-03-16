import 'dart:math';
import 'package:intl/intl.dart';
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
    } else if (userRoles.contains(6)) {
      userRole = 'secretary';
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

  String convertInputId(String uniqueId){
    return uniqueId.split('_')[1];
  }


  String formatFluraDate(String? date) {
    /*
    if(date != null && date.trim().isEmpty) return 'Нет даты';
    try{
      final dt = DateTime.parse(date!);
      return DateFormat('dd.MM.yyyy').format(dt);
    } catch(e){
      return 'Неверный формат';
    }

     */

    if (date == null) {
      print('Нет даты');
      return 'Нет даты';
    }
    try{
      //final dt = DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
      final dt = date;
      print('Есть дата: $dt');
      return dt;
      // final dateTime = DateTime.parse(date);
      // final String convertedTime =
      //     '${dateTime.day.toString().padLeft(2, '0')}'
      //     '.${dateTime.month.toString().padLeft(2, '0')}'
      //     '.${dateTime.year}';
      // return convertedTime;
    } catch (e){
      //print('Неверный формат даты $date');
      return 'Catch - нет даты';
    }

  }

}
