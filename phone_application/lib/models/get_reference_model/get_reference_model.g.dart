// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetReferenceModel _$GetReferenceModelFromJson(Map<String, dynamic> json) =>
    _GetReferenceModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      patronymic: json['patronymic'] as String,
      group: json['group'] as String,
      typeId: (json['typeId'] as num).toInt(),
      statusId: (json['statusId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      date: json['date'] as String,
      phone: json['phone'] as String,
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
