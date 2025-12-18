import 'package:flutter/foundation.dart';

class UserData {
  final int id;
  final String firstname;
  final String lastname;
  String? patronymic;
  final int network_city_id;
  final List<int> roles;
  final List<String> groups;

  UserData({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.patronymic,
    required this.network_city_id,
    required this.roles,
    this.groups = const [],
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'];
    final groups = json['groups'];

    List<int> rolesList = [];
    if(roles is List){
      rolesList = roles.map((e) => e as int).toList();
    }

    List<String> groupsList = [];
    if(groups is List){
      groupsList = groups.map((e) => e as String).toList();
    }

    return UserData(
      id: json['id'] as int? ?? 0,
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      patronymic: json['patronymic'] as String? ?? '',
      network_city_id: json['network_city_id'] as int? ?? 0,
      roles: rolesList,
      groups: groupsList,
    );
  }
}

