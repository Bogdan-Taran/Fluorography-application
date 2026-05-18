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
import 'package:dartz/dartz.dart';
import 'package:talker/talker.dart';

class ApiServiceGetCommunityMembers {
  final talker = Talker();
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
        talker.warning('401 - Ошибка авторизации');
        final List<dynamic> jsonError = jsonDecode(response.data);
        return jsonError
            .whereType<Map<String, dynamic>>()
            .map((json) => StaffModel.fromJson(json))
            .toList();
      } else {
        talker.error('');
        talker.error('Произошла на стороне сервера при получении сотрудников');
        final List<dynamic> jsonError = jsonDecode(response.data);
        return jsonError
            .whereType<Map<String, dynamic>>()
            .map((json) => StaffModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      talker.handle(e);
      // final List<dynamic> jsonError = jsonDecode(response.data);
      return finalStaffList;
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
      talker.warning('Ошибка 401 - надо авторизироваться');
      final errorData = jsonDecode(response.body);
      return errorData;
    } else {
      talker.error('Произошла ошибка при получении списка групп');
      final errorData = jsonDecode(response.body);
      return errorData;
    }
  }

  /*
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
  }*/

/*
  Future<List<SingleGroupWithStudentsModel>> getGroupsForAdmin() async {
    List<SingleGroupWithStudentsModel> finalListAllGroupsForAdmin = [];
    try {
      finalListAllGroupsForAdmin = await getAllGroupsIteration();
      return finalListAllGroupsForAdmin;
    } catch (e) {
      print('Произошла ошибка при попытке получить группы для админа');
    }
    return finalListAllGroupsForAdmin;
  }*/

/*
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
  }*/

  Future<List<StaffAndStudentsModel>> getAllComuintyForMedic() async {
    final List<StaffAndStudentsModel> finalListAllCommunityForMedic = [];
    final List<StaffModel> staffList;
    final List<SingleGroupWithStudentsModel> studentsList;
    try {
      talker.info('Получаю сотрудников');
      staffList = await getStaffDio();
      // staffList = await getStaff();
      // print(staffList.toString());
      talker.info('Получаю студентов');
      final resultStudents = await getStudentsWithFluraDio();
      resultStudents.fold(
              (error) => talker.error('Ошибка: ${error['data']}'),
              (students) {
          talker.info('Студенты получены: ${students.length}');
          finalListAllCommunityForMedic.add(
            StaffAndStudentsModel(staffList: staffList, studentsList: students),
          );
        }
      );

      // print(finalListAllCommunityForMedic);
    } catch (e) {
      log(e.toString());
      talker.handle(e);
      talker.error('Ошибка при получении сотрудников или студентов');
    }
    return finalListAllCommunityForMedic;
  }

  Future<Either<Map<String, dynamic>, List<SingleGroupWithStudentsModel>>> getStudentsWithFluraDio() async {
    try {
      final token = await getToken();
      if(token == null) {
        return Left({'statusCode': 401, 'data': 'Токен отсутствует'});
      }
      Response response;
      try{
        response = await dio.get(
        '/api/students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      } catch (e) {
        if (e is DioException) {
          if (e.response?.statusCode == 403) {
            return Left({
              'statusCode': 403,
              'data': 'У вас нет доступа к этой странице'
            });
          }
          return Left({
            'statusCode': e.response?.statusCode ?? 0,
            'data': 'Ошибка сервера: ${e.response?.statusCode}',
          });
        }
        return Left({'statusCode': 0, 'data': e.toString()});
      }
      talker.debug("Тип response.data: ${response.data.runtimeType}");
      talker.debug("Содержимое response.data: ${response.data}");

      if (response.data is Map && response.data.containsKey('message')){
        return Left({
          'statusCode': response.statusCode ?? 200,
          'data': response.data['message'],
        });
      }

      if (response.statusCode == 200) {
        List<dynamic> jsonDataList;

        if(response.data is List){
          jsonDataList = response.data;
        }
        else if(response.data is Map && response.data['data'] is List){
          jsonDataList = response.data['data'];
        }
        else if(response.data is Map && response.data['students'] is List){
          jsonDataList = response.data['students'];
        }
        else if (response.data is Map){
          jsonDataList = [response.data];
        }else{
          talker.error('Пришёл неизвестный формат данных');
          return Left({'statusCode': 500, 'data': 'Ошибка сервера: ${response.statusCode}'});
        }
        if(jsonDataList.isEmpty){
          return Left({
            'statusCode': 200,
            'data': 'Список студентов пуст'
          });
        }
        try {
          final List<StudentData> students = jsonDataList
              .whereType<Map<String, dynamic>>()
              .map((json) => StudentData.fromJson(json))
              .toList();
          if (students.isEmpty) {
            return Left({
              'statusCode': 200,
              'data': 'Не удалось преобразовать список студентов'
            });
          }
          final groupedMap = <String, List<StudentData>>{};
          for (var student in students) {
            String groupNumber = student.group;
            if (!groupedMap.containsKey(groupNumber)) {
              groupedMap[groupNumber] = [];
            }
            groupedMap[groupNumber]?.add(student);
          }
          final List<
              SingleGroupWithStudentsModel> finalListAllGroups = groupedMap
              .entries.map((entry) =>
              SingleGroupWithStudentsModel(
                  groupNumber: entry.key, students: entry.value)).toList();
          return Right(finalListAllGroups);
        }catch(e){
          return Left({
          'statusCode': 200,
            'data': 'Ошибка преобразования данных: ${e.toString()}'
          });
        }
      }
      else if (response.statusCode == 401) {
        talker.warning('401 - Ошибка авторизации');
        return Left({'statusCode': 401, 'data': 'Ошибка авторизации'});
      } else {
        print('Произошла неизвестная ошибка при получении студентов');
        print(response.statusCode);
        return Left({'statusCode': 500, 'data': 'Произошла неизвестная ошибка при получении студентов'});
      }

    } catch (e) {
      talker.handle(e);
      return Left({'statusCode': 0, 'data': 'Произошла ошибка: $e'});
    }
  }
}



