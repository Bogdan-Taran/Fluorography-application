import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_reference_model.freezed.dart';
part 'get_reference_model.g.dart';
@freezed
abstract class GetReferenceModel with _$GetReferenceModel {
  factory GetReferenceModel({
    @Default(0) int id,
    @Default(0) int userId,
    @Default('Имя не указано') String firstname,
    @Default('Фамилия не указана') String lastname,
    @Default('Отчество не указано') String patronymic,
    @Default('Группа не указана') String group,
    @Default(0) int typeId,
    @Default(0) int statusId,
    @Default(0) int quantity,
    @Default('00.00.0000') String date,
    @Default('Не указан') String phone,
  }) = _GetReferenceModel;
  factory GetReferenceModel.fromJson(Map<String, dynamic> json) => _$GetReferenceModelFromJson(json);
}