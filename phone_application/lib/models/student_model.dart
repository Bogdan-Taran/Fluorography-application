import 'package:flutter/foundation.dart';


@immutable
class StudentData {
  final int id;
  final String lastname;
  final String firstname;
  final String? patronymic;
  final String? fluorography;
  final String group;


  const StudentData({
    required this.id,
    required this.lastname,
    required this.firstname,
    this.patronymic,
    required this.fluorography,
    required this.group
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['id'] as int? ?? 0,
      lastname: json['lastname'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      patronymic: json['patronymic'] as String? ?? '',
      fluorography: json['fluorography'] as String? ?? '',
      group: json['group'] as String? ?? '',
    );
  }
}