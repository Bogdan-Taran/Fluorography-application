import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_fluorography/styles.dart';
part 'get_reference_model.freezed.dart';
part 'get_reference_model.g.dart';
@freezed
abstract class GetReferenceModel with _$GetReferenceModel {
  factory GetReferenceModel({
    @Default(0) int id,
    @Default(0) int user_id,
    @Default('Имя не указано') String firstname,
    @Default('Фамилия не указана') String lastname,
    @Default('Отчество не указано') String patronymic,
    @Default('Группа не указана') String group,
    @Default(0) int type_id,
    @Default(0) int status_id,
    @Default(0) int quantity,
    @Default('00.00.0000') String date,
    @Default('Телефон не указан') String phone,
  }) = _GetReferenceModel;
  factory GetReferenceModel.fromJson(Map<String, dynamic> json) => _$GetReferenceModelFromJson(json);
}

extension StatusId on int {
  String get statusName{
    return {
      1: 'В процессе',
      2: 'Готово',
      3: 'Дубликат',
    }[this] ?? 'Неизвестно';
  }
  Color get statusColor{
    return{
      1: AppStyle.yellowProcessColor,
      2: AppStyle.statusReadyGreenColor18CC00,
      3: AppStyle.redColorTag,
    }[this] ?? AppStyle.yellowProcessColor;
  }
  String get applicationTypeName{
    return{
      1: 'Справка об обучении',
      2: 'Справка для пенсионного фонда',
      3: 'Справка в военный комиссариат'
    }[this] ?? 'Неизвестная справка';
  }
}