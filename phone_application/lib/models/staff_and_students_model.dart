import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_model.dart';

@immutable

class StaffAndStudentsModel {
  final List<StaffModel> staffList;
  final List<SingleGroupWithStudentsModel> studentsList;

  StaffAndStudentsModel({
    required this.staffList,
    required this.studentsList});

  // factory StaffAndStudentsModel.fromJson(Map<String, dynamic> json){
  //
  // }
}