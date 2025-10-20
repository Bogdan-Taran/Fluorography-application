import 'roles.dart';

class Users {
  final int? id;
  final String? login;
  final String? password;
  final String? createdAt;
  final String? updatedAt;
  final String? roles;

  Users({this.id, this.login, this.password, this.createdAt, this.updatedAt, this.roles})

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      id: json['id'] as int,
      login: json['login'] as String,
      password: json['password'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      roles: Roles.fromJson(json['Role'])
    );
  }

  @override
  String toString(){
    return 'Users{name: $login}';
  }
}