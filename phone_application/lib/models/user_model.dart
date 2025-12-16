import 'package:flutter/foundation.dart';

@immutable
class UserData {
  final int id;
  final String firstname;
  final String lastname;
  final String patronymic;
  final int network_city_id;
  final List<int> roles;
  final List<String> groups;

  UserData({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.patronymic,
    required this.network_city_id,
    required this.roles,
    required this.groups,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      patronymic: json['patronymic'] as String,
      network_city_id: json['network_city_id'] as int,
      roles: json['roles'] as List<int>,
      groups: json['groups'] as List<String>,
    );
  }
}

@immutable
class UserRole {
  final List<String> roles;

  const UserRole({
    required this.roles
  });

  factory UserRole.fromJson(Map<String, dynamic> json){
    return UserRole(
      roles: json["roles"]
    );
  }
}
