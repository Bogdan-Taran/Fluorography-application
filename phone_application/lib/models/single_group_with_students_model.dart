import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/student_model.dart';

@immutable
class SingleGroupWithStudentsModel {
  final String groupNumber;
  final List<StudentData> students;

  SingleGroupWithStudentsModel({
    required this.groupNumber,
    required this.students,
  });

  factory SingleGroupWithStudentsModel.initial(String groupNumber) {
    return SingleGroupWithStudentsModel(groupNumber: groupNumber, students: []);
  }

  SingleGroupWithStudentsModel copyWith({
    String? groupNumber,
    List<StudentData>? students,
  }) {
    return SingleGroupWithStudentsModel(
      groupNumber: groupNumber ?? this.groupNumber,
      students: students ?? this.students,
    );
  }
}
