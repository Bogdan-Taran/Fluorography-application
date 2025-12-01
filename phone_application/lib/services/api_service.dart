import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:project_fluorography/models/student_models.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.13.19';

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('auth_token');

    if(token == null) {
      await _login();
      final newToken = await prefs.getString('auth_token');
      if(newToken == null){
        throw Exception('Не удалось получить токен после логина');
      }
      return newToken;
    }

    return token;
  }

  Future<void> _login() async {
    final loginResponse = await http.post(
        Uri.parse('$_baseUrl/api/login'),
      body: {'login': 'hom', 'password': '57020594'},
    );
    if (loginResponse.statusCode != 200){
      throw Exception('Неверный логин или пароль');
    }
    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'] as String?;
    if(token == null) throw Exception('Токен не получен');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }



  Future<List<Group>> fetchGroups() async {
    final token = await _getAuthToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/api/groups'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      final List<Group> groups = jsonList.whereType<Map<String, dynamic>>().map((map) => Group.fromJson(map)).toList();

      print('Всего групп: ${groups.length}');
      for (var group in groups) {
        print('ID: ${group.id}, Number: ${group.number}');
      }
      return groups;
    } else{
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Student>> fetchStudentsByGroupNumber(String groupNumber) async{
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/students?group=$groupNumber'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if(response.statusCode == 200){
      final List<dynamic> rawList = jsonDecode(response.body);
      return rawList.whereType<Map<String, dynamic>>().map((json) => Student.fromJson(json)).toList();
    } else{
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  Future<List<GroupWithStudents>> fetchAllGroupsWithStudents() async {
    final groups = await fetchGroups();
    final List<GroupWithStudents> result = [];

    for(final group in groups) {
      try {
        final students = await fetchStudentsByGroupNumber(group.number);
        result.add(
          GroupWithStudents(groupNumber: group.number, students: students)
        );
      } catch (e){
        print('Ошибка загрузки студентов для группы ${group.number}: $e');
        result.add(GroupWithStudents.initial(group.number));
      }
    }
    return result;
  }

  Future<GroupWithStudents> fetchGroupWithStudents(String groupNumber) async{
    final students = await fetchStudentsByGroupNumber(groupNumber);
    return GroupWithStudents(
      groupNumber: groupNumber,
      students: students
    );
  }

  Future<User> getCurrentUser() async {
    return User(
      login: 'test_user',
      role: UserRole.medic,
      group: null,
    );
  }

}

