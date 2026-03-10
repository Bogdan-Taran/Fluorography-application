// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetReferenceModel _$GetReferenceModelFromJson(Map<String, dynamic> json) =>
    _GetReferenceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      firstname: json['firstname'] as String? ?? 'Имя не указано',
      lastname: json['lastname'] as String? ?? 'Фамилия не указана',
      patronymic: json['patronymic'] as String? ?? 'Отчество не указано',
      group: json['group'] as String? ?? 'Группа не указана',
      typeId: (json['typeId'] as num?)?.toInt() ?? 0,
      statusId: (json['statusId'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      date: json['date'] as String? ?? '00.00.0000',
      phone: json['phone'] as String? ?? 'Не указан',
    );

Map<String, dynamic> _$GetReferenceModelToJson(_GetReferenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'patronymic': instance.patronymic,
      'group': instance.group,
      'typeId': instance.typeId,
      'statusId': instance.statusId,
      'quantity': instance.quantity,
      'date': instance.date,
      'phone': instance.phone,
    };
