import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_reference_model.freezed.dart';
part 'get_reference_model.g.dart';
@freezed
abstract class GetReferenceModel with _$GetReferenceModel {
  factory GetReferenceModel({
    required int id,
    required int userId,
    required String firstname,
    required String lastname,
    required String patronymic,
    required String group,
    required int typeId,
    required int statusId,
    required int quantity,
    required String date,
    required String phone,
  }) = _GetReferenceModel;
  factory GetReferenceModel.fromJson(Map<String, dynamic> json) => _$GetReferenceModelFromJson(json);
}