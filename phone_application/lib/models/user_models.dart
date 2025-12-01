import 'student_models.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String? patronymic;
  final int networkCityId;
  final List<int> roles;
  final String? groupNumber;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.patronymic,
    required this.networkCityId,
    required this.roles,
    this.groupNumber,
});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] as int? ?? 0,
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      patronymic: json['patronymic'] as String?,
      networkCityId: json['network_city_id'] as int? ?? 0,
      roles: List<int>.from(json['roles'] ?? []),
      groupNumber: json['group_number'] as String?
    );
  }

  UserRole get userRole {
    if (roles.contains(1)) return UserRole.medic;
    if (roles.contains(4)) return UserRole.administrator;
    if (roles.contains(5)) return UserRole.curator;

    return UserRole.medic;
  }
}

enum UserRole {medic, curator, administrator}
