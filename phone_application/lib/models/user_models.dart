import 'student_models.dart';

enum UserRole {medic, curator, administrator, student, employee}

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String? patronymic;
  final int networkCityId;
  final List<int> roles;
  final List<String> groups;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.patronymic,
    required this.networkCityId,
    required this.roles,
    this.groups = const [],
});

  factory User.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'];
    final groups = json['groups'];

    List<int> rolesList = [];
    if (roles is List) {
      rolesList = roles.map((e) => e as int).toList();
    }

    List<String> groupsList = [];
    if (groups is List) {
      groupsList = groups.map((e) => e.toString()).toList();
    }

    return User(
      id: json['id'] as int? ?? 0,
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      patronymic: json['patronymic'] as String?,
      networkCityId: json['network_city_id'] as int? ?? 0,
      roles: rolesList,
      groups: groupsList,
    );
  }

  UserRole get userRole {
    if (roles.contains(1)) return UserRole.medic;      // medic
    if (roles.contains(4)) return UserRole.administrator; // admin
    if (roles.contains(5)) return UserRole.curator;    // curator
    if (roles.contains(2)) return UserRole.student;    // student
    if (roles.contains(3)) return UserRole.employee;   // employee

    return UserRole.medic;
  }

  List<String> get curatorGroups {
    return roles.contains(5) ? groups : [];
  }
  bool get isCurator => roles.contains(5);
  bool get isAdmin => roles.contains(4);
  bool get isMedic => roles.contains(1);

}


