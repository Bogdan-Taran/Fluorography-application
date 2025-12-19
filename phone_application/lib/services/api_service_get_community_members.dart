import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:project_fluorography/models/group_model.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceGetCommunityMembers {
  final String _baseUrl = 'http://flura.tomtit-tomsk.ru';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Map<String, dynamic>> getStaff() async {
    final token = getToken();
    final url = Uri.parse('$_baseUrl/api/employees');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return {'success': true, 'data': jsonData};
    } else {
      print('Произошла ошибка при получении сотрудников');
      final errorData = jsonDecode(response.body);
      return {'success': false, 'error': errorData};
    }
  }

  Future<List<GroupModel>> getGroups() async {
    final token = await getToken();
    final url = Uri.parse('$_baseUrl/api/groups');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      final List<GroupModel> groups = jsonList
          .whereType<Map<String, dynamic>>()
          .map((map) => GroupModel.fromJson(map))
          .toList();
      return groups;
    } else if (response.statusCode == 401) {
      print('Ошибка 401 - надо авторизироваться');
      final errorData = jsonDecode(response.body);
      return errorData;
    } else {
      print('Произошла ошибка при получении списка групп');
      final errorData = jsonDecode(response.body);
      return errorData;
    }
  }

  Future<List<StudentData>> getStudentsListByGroupNumber(String group) async {
    final token = getToken();
    final url = Uri.parse('$_baseUrl/api/students?group=$group');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = jsonDecode(response.body);
      return jsonDataList
          .whereType<Map<String, dynamic>>()
          .map((json) => StudentData.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      print('401 - Ошибка авторизации');
      final List<dynamic> jsonError = jsonDecode(response.body);
      return jsonError
          .whereType<Map<String, dynamic>>()
          .map((json) => StudentData.fromJson(json))
          .toList();
    } else {
      print('Произошла ошибка при получении студентов группы $group');
      final List<dynamic> jsonError = jsonDecode(response.body);
      return jsonError
          .whereType<Map<String, dynamic>>()
          .map((json) => StudentData.fromJson(json))
          .toList();
    }
  }

  Future<List<SingleGroupWithStudentsModel>> getGroupsForCurator() async {
    List<String>? curatorGroups;
    final List<SingleGroupWithStudentsModel> finalListAllGroupsForCurator = [];

    try {
      final prefs = await SharedPreferences.getInstance();
      curatorGroups = prefs.getStringList('groups')!;
    } catch (e) {
      print('В памяти не сохранено ни одно группы куратора');
    }
    for(final group in curatorGroups!){
      try {
        final students = await getStudentsListByGroupNumber(group);
        finalListAllGroupsForCurator.add(
          SingleGroupWithStudentsModel(
            groupNumber: group,
            students: students,
          ),
        );
      } catch (e) {
        print('Ошибка при загрузке студентов группы $group');
        finalListAllGroupsForCurator.add(
          SingleGroupWithStudentsModel.initial(group),
        );
      }
    }
    return finalListAllGroupsForCurator;


  }

  Future<List<SingleGroupWithStudentsModel>> getAllGroupsIteration() async {
    final groups = await getGroups();
    final List<SingleGroupWithStudentsModel> finalListAllGroups = [];

    for (final group in groups) {
      try {
        final students = await getStudentsListByGroupNumber(group.number);
        finalListAllGroups.add(
          SingleGroupWithStudentsModel(
            groupNumber: group.number,
            students: students,
          ),
        );
      } catch (e) {
        print('Ошибка при загрузке студентов группы $group');
        finalListAllGroups.add(
          SingleGroupWithStudentsModel.initial(group.number),
        );
      }
    }
    return finalListAllGroups;
  }
}
