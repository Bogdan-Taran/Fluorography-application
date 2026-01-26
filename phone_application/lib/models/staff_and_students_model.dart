import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'multipleGroupsModel.dart';

@immutable
class StaffAndStudentsModel implements MultiplieGroupsModel{
  final List<StaffModel> staffList;
  final List<SingleGroupWithStudentsModel> studentsList;

  StaffAndStudentsModel({required this.staffList, required this.studentsList});
  
  Map<String, dynamic> toJson(){
    return{
      'staffList': staffList.map((staff) => staff.toJson()).toList(),
      'studentsList': studentsList.map((e) => e.toJson()).toList()
    };
  }

  factory StaffAndStudentsModel.fromJson(Map<String, dynamic> json){
    return StaffAndStudentsModel(
        staffList: (json['staffList'] as List<dynamic>).map((staff) => StaffModel.fromJson(staff)).toList(),
        studentsList: (json['studentsList'] as List<dynamic>).map((group) => SingleGroupWithStudentsModel.fromJson(group)).toList()
    );
  }
  String toCacheString() => jsonEncode(toJson());
  static StaffAndStudentsModel fromCacheString(String str) =>
      StaffAndStudentsModel.fromJson(jsonDecode(str));
  
}
