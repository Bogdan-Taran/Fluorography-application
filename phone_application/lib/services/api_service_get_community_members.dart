import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:project_fluorography/models/group_model.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ApiServiceGetCommunityMembers {
  final String _baseUrl = 'https://flura.tomtit-tomsk.ru';
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<List<StaffModel>> getStaffDio() async {
    final token = await getToken();
    List<StaffModel> finalStaffList = [];
    try {
      Response response = await dio.get(
        '/api/employees',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonDataList =
        response.data as List<dynamic>;
        return jsonDataList
            .whereType<Map<String, dynamic>>()
            .map((json) => StaffModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        print('401 - Ошибка авторизации');
        final List<dynamic> jsonError = jsonDecode(response.data);
        return jsonError
            .whereType<Map<String, dynamic>>()
            .map((json) => StaffModel.fromJson(json))
            .toList();
      } else {
        print('Ошибка на стороне сервера');
        print('Произошла ошибка при получении сотрудников');
        final List<dynamic> jsonError = jsonDecode(response.data);
        return jsonError
            .whereType<Map<String, dynamic>>()
            .map((json) => StaffModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print(e);
      // final List<dynamic> jsonError = jsonDecode(response.data);
      return finalStaffList;
    }
  }

  Future<List<SingleGroupWithStudentsModel>> getStudentsWithFluraDio() async {
    final token = await getToken();
    try {
      Response response = await dio.get(
        '/api/students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonDataList = response.data;
        final List<StudentData> students = jsonDataList
            .whereType<Map<String, dynamic>>()
            .map((json) => StudentData.fromJson(json))
            .toList();
        final groupedMap = <String, List<StudentData>>{};
        for(var student in students){
          String groupNumber = student.group;
          if(!groupedMap.containsKey(groupNumber)){
            groupedMap[groupNumber] = [];
          }
          groupedMap[groupNumber]?.add(student);
        }
        final List<SingleGroupWithStudentsModel> finalListAllGroups = groupedMap.entries.map((entry) => SingleGroupWithStudentsModel(groupNumber: entry.key, students: entry.value)).toList();
        return finalListAllGroups;

      } else if (response.statusCode == 401) {
        print('401 - Ошибка авторизации');
        final List<dynamic> jsonError = response.data;
        return [];
      } else {
        print('Произошла неизвестная ошибка при получении студентов');
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<StaffModel>> getStaff() async {
    final token = await getToken();
    final url = Uri.parse('$_baseUrl/api/employees');
    // print('Token: $token');
    // print('Отпавляю запрос на получние сотрудников');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList =
          jsonDecode(response.body) as List<dynamic>;
      // print(jsonDataList);
      return jsonDataList
          .whereType<Map<String, dynamic>>()
          .map((json) => StaffModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      print('401 - Ошибка авторизации');
      final List<dynamic> jsonError = jsonDecode(response.body);
      return jsonError
          .whereType<Map<String, dynamic>>()
          .map((json) => StaffModel.fromJson(json))
          .toList();
    } else {
      print('Произошла ошибка при получении сотрудников');
      final List<dynamic> jsonError = jsonDecode(response.body);
      return jsonError
          .whereType<Map<String, dynamic>>()
          .map((json) => StaffModel.fromJson(json))
          .toList();
    }
  }

  // "id": 1,
  // "number": "422"
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
    // print('Начинаю получение студентов');
    final token = await getToken();
    // print('token: $token');
    final url = Uri.parse('$_baseUrl/api/students?group=$group');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print('отправил запрос');
    // print('status code:');
    // print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = jsonDecode(response.body);
      // print(jsonDataList);
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
      print(response.statusCode);
      final List<dynamic> jsonError = jsonDecode(response.body);
      return jsonError
          .whereType<Map<String, dynamic>>()
          .map((json) => StudentData.fromJson(json))
          .toList();
    }
  }


  Future<List<SingleGroupWithStudentsModel>> getGroupsForAdmin() async {
    List<SingleGroupWithStudentsModel> finalListAllGroupsForAdmin = [];
    try {
      finalListAllGroupsForAdmin = await getAllGroupsIteration();
      return finalListAllGroupsForAdmin;
    } catch (e) {
      print('Произошла ошибка при попытке получить группы для админа');
    }
    return finalListAllGroupsForAdmin;
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

  Future<List<StaffAndStudentsModel>> getAllComuintyForMedic() async {
    final List<StaffAndStudentsModel> finalListAllCommunityForMedic = [];
    final List<StaffModel> staffList;
    final List<SingleGroupWithStudentsModel> studentsList;
    try {
      print('Получаю сотрудников');
      staffList = await getStaffDio();
      // staffList = await getStaff();
      // print(staffList.toString());
      print('Получаю студентов');
      studentsList = await getStudentsWithFluraDio();
      // studentsList = await getAllGroupsIteration();
      // print(studentsList.toString());
      finalListAllCommunityForMedic.add(
        StaffAndStudentsModel(staffList: staffList, studentsList: studentsList),
      );
      // print(finalListAllCommunityForMedic);
    } catch (e) {
      log(e.toString());
      print(e);
      print('Ошибка при получении сотрудников или студентов');
    }
    return finalListAllCommunityForMedic;
  }
}
