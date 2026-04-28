// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetReferenceModel _$GetReferenceModelFromJson(Map<String, dynamic> json) =>
    _GetReferenceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      user_id: (json['user_id'] as num?)?.toInt() ?? 0,
      firstname: json['firstname'] as String? ?? 'Имя не указано',
      lastname: json['lastname'] as String? ?? 'Фамилия не указана',
      patronymic: json['patronymic'] as String? ?? 'Отчество не указано',
      group: json['group'] as String? ?? 'Группа не указана',
      type_id: (json['type_id'] as num?)?.toInt() ?? 0,
      status_id: (json['status_id'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      date: json['date'] as String? ?? '00.00.0000',
      phone: json['phone'] as String? ?? 'Телефон не указан',
    );

Map<String, dynamic> _$GetReferenceModelToJson(_GetReferenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'patronymic': instance.patronymic,
      'group': instance.group,
      'type_id': instance.type_id,
      'status_id': instance.status_id,
      'quantity': instance.quantity,
      'date': instance.date,
      'phone': instance.phone,
    };
