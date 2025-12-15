import 'package:flutter/foundation.dart';


@immutable
class StudentData {
  final int id;
  final String lastname;
  final String firstname;
  final String patronymic;
  final String? fluorography;
  final String group;

  const StudentData({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.patronymic,
    required this.fluorography,
    required this.group
  });
}