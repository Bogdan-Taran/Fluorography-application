import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_reference_model.freezed.dart';
part 'post_reference_model.g.dart';
@freezed
abstract class PostReferenceModel with _$PostReferenceModel {
  factory PostReferenceModel({
    required String firstname,
    required String lastname,
    required String patronymic,
    required String group,
    required int type_id,
    required String phone,
    required int quantity,
  }) = _PostReferenceModel;
  factory PostReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$PostReferenceModelFromJson(json);
}
