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
    required this.group,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    ConverterServices _converterService = ConverterServices();
    String fluorography = _converterService.formatFluraDate(
      json['fluorography'],
    );

    return StudentData(
      id: json['id'] as int? ?? 0,
      lastname: json['lastname'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      patronymic: json['patronymic'] as String? ?? '',
      fluorography: fluorography,
      group: json['group'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['patronymic'] = this.patronymic;
    data['fluorography'] = this.fluorography;
    data['group'] = this.group;
    return data;
  }

  String get searchKey =>
      '$lastname $firstname $patronymic $group'.toLowerCase();

  StudentData copyWith({String? fluorography}) {
    return StudentData(
      id: id,
      lastname: lastname,
      firstname: firstname,
      fluorography: fluorography ?? this.fluorography,
      group: group,
    );
  }
}
