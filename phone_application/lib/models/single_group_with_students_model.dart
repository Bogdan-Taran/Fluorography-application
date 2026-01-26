import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'dart:convert';

import 'multipleGroupsModel.dart';
@immutable
class SingleGroupWithStudentsModel implements MultiplieGroupsModel{
  final String groupNumber;
  final List<StudentData> students;

  SingleGroupWithStudentsModel({
    required this.groupNumber,
    required this.students,
  });

  //convert to json
  Map<String, dynamic> toJson(){
    return{
      'groupNumber': groupNumber,
      'students': students.map((student) => student.toJson()).toList(),
    };
  }
  //convert from json
  factory SingleGroupWithStudentsModel.fromJson(Map<String, dynamic> json){
    return SingleGroupWithStudentsModel(
        groupNumber: json['groupNumber'] as String,
        students: (json['students'] as List<dynamic>).map((student) => StudentData.fromJson(student)).toList(),
    );
  }

  //convert to string to store in SQL
  String toCacheString() => jsonEncode(toJson());
  //convert from string
  static SingleGroupWithStudentsModel fromCacheString(String str) =>
      SingleGroupWithStudentsModel.fromJson(jsonDecode(str));

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
