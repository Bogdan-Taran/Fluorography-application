import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/services/api_reference/dio_and_interceptors/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

part 'medic_repository.g.dart';

@riverpod
MedicRepository medicRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MedicRepository(dio);
}

class MedicRepository {
  final Dio _dio;
  final talker = Talker();

  MedicRepository(this._dio);

  Future<List<SingleGroupWithStudentsModel>> getStudents() async {
    try {
      talker.info('MedicRepo: загрузка студентов');
      final response = await _dio.get('/api/students');
      
      final List<StudentData> rawStudents = [];
      final studentsData = response.data;
      
      if (studentsData is List) {
        rawStudents.addAll(studentsData.map((json) => StudentData.fromJson(json)));
      } else if (studentsData is Map) {
        final list = studentsData['students'] ?? studentsData['data'] ?? [];
        rawStudents.addAll((list as List).map((json) => StudentData.fromJson(json)));
      }

      final groupedMap = <String, List<StudentData>>{};
      for (var student in rawStudents) {
        groupedMap.putIfAbsent(student.group, () => []).add(student);
      }

      return groupedMap.entries
          .map((entry) => SingleGroupWithStudentsModel(
                groupNumber: entry.key,
                students: entry.value,
              ))
          .toList();
    } catch (e) {
      talker.handle('MedicRepo (getStudents) error: $e');
      rethrow;
    }
  }

  Future<List<StaffAndStudentsModel>> getEntireCommunity() async {
    try {
      talker.info('MedicRepo: загрузка людей (сотрудники, студенты)');
      
      final results = await Future.wait([
        _dio.get('/api/employees'),
        getStudents(),
      ]);

      final staffResponse = results[0] as Response;
      final List<SingleGroupWithStudentsModel> studentGroups = results[1] as List<SingleGroupWithStudentsModel>;

      final List<StaffModel> staff = (staffResponse.data as List)
          .map((json) => StaffModel.fromJson(json))
          .toList();

      talker.log('MedicRepo: Успешно загружено ${staff.length} сотрудников и ${studentGroups.length} групп студентов');
      
      return [
        StaffAndStudentsModel(staffList: staff, studentsList: studentGroups)
      ];
    } catch (e) {
      talker.handle('MedicRepo error: $e');
      rethrow;
    }
  }

  Future<void> updateFluorographyDate(int userId, String date) async {
    try {
      await _dio.patch('/api/fluorography/$userId', data: {
        'date': date,
      });
    } catch (e) {
      talker.handle('MedicRepo (updateDate) Error: $e');
      rethrow;
    }
  }
}
