// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostReferenceModel _$PostReferenceModelFromJson(Map<String, dynamic> json) =>
    _PostReferenceModel(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      patronymic: json['patronymic'] as String,
      group: json['group'] as String,
      type_id: (json['type_id'] as num).toInt(),
      phone: json['phone'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PostReferenceModelToJson(_PostReferenceModel instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'patronymic': instance.patronymic,
      'group': instance.group,
      'type_id': instance.type_id,
      'phone': instance.phone,
      'quantity': instance.quantity,
    };
