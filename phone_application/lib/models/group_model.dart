import 'package:flutter/foundation.dart';


@immutable
class GroupModel {
  final int id;
  final String number;

  GroupModel({
    required this.id,
    required this.number,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int? ?? 0,
      number: json['number'] as String? ?? '',
    );
  }
}