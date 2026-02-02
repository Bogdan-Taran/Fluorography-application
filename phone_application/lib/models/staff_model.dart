// "id": 140,
// "lastname": "Захаров",
// "firstname": "Максим",
// "patronymic": "Иванович",
// "groups": [
// "422"
// ],
// "fluorography": "2025-07-11"

import 'package:meta/meta.dart';

import '../services/converters_service.dart';

@immutable
class StaffModel {
  final int id;
  final String lastname;
  final String firstname;
  final String patronymic;
  final List<String> groups;
  final String? fluorography;

  const StaffModel({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.patronymic,
    required this.groups,
    required this.fluorography,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json){
    final rawGroups = json['groups'];
    List<String> groups = <String>[];
    if(rawGroups is List){
      groups = rawGroups.map((e) => e.toString()).toList();
    }

    ConverterServices _converterService = ConverterServices();
    String fluorography = _converterService.formatFluraDate(json['fluorography']);

    return StaffModel(
        id: json['id'] as int ?? 0,
        lastname: json['lastname'] as String? ?? '',
        firstname: json['firstname'] as String? ?? '',
        patronymic: json['patronymic'] as String? ?? '',
        groups: groups,
        fluorography: fluorography
        // fluorography: json['fluorography'] as String ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['patronymic'] = this.patronymic;
    data['groups'] = this.groups;
    data['fluorography'] = this.fluorography;
    return data;
  }

  String get searchKey =>
      '$lastname $firstname $patronymic $groups'.toLowerCase();

  StaffModel copyWith({String? fluorography}){
    return StaffModel(
      id: id,
      lastname: lastname,
      firstname: firstname,
      patronymic: patronymic,
      groups: groups,
      fluorography: fluorography ?? this.fluorography,
    );
  }


}
