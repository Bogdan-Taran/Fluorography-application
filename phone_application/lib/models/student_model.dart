import 'package:flutter/foundation.dart';

import '../services/converters_service.dart';


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

    ConverterServices _converterService = ConverterServices();
    String fluorography = _converterService.formatFluraDate(json['fluorography']);

    return StudentData(
      id: json['id'] as int? ?? 0,
      lastname: json['lastname'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      patronymic: json['patronymic'] as String? ?? '',
      fluorography: fluorography,
      group: json['group'] as String? ?? '',
    );
  }
}