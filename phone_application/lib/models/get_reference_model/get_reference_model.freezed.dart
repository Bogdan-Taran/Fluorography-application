// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetReferenceModel {

 int get id; int get userId; String get firstname; String get lastname; String get patronymic; String get group; int get typeId; int get statusId; int get quantity; String get date; String get phone;
/// Create a copy of GetReferenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetReferenceModelCopyWith<GetReferenceModel> get copyWith => _$GetReferenceModelCopyWithImpl<GetReferenceModel>(this as GetReferenceModel, _$identity);

  /// Serializes this GetReferenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetReferenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.patronymic, patronymic) || other.patronymic == patronymic)&&(identical(other.group, group) || other.group == group)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.statusId, statusId) || other.statusId == statusId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.date, date) || other.date == date)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,firstname,lastname,patronymic,group,typeId,statusId,quantity,date,phone);

@override
String toString() {
  return 'GetReferenceModel(id: $id, userId: $userId, firstname: $firstname, lastname: $lastname, patronymic: $patronymic, group: $group, typeId: $typeId, statusId: $statusId, quantity: $quantity, date: $date, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $GetReferenceModelCopyWith<$Res>  {
  factory $GetReferenceModelCopyWith(GetReferenceModel value, $Res Function(GetReferenceModel) _then) = _$GetReferenceModelCopyWithImpl;
@useResult
$Res call({
 int id, int userId, String firstname, String lastname, String patronymic, String group, int typeId, int statusId, int quantity, String date, String phone
});




}
/// @nodoc
class _$GetReferenceModelCopyWithImpl<$Res>
    implements $GetReferenceModelCopyWith<$Res> {
  _$GetReferenceModelCopyWithImpl(this._self, this._then);

  final GetReferenceModel _self;
  final $Res Function(GetReferenceModel) _then;

/// Create a copy of GetReferenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? firstname = null,Object? lastname = null,Object? patronymic = null,Object? group = null,Object? typeId = null,Object? statusId = null,Object? quantity = null,Object? date = null,Object? phone = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,patronymic: null == patronymic ? _self.patronymic : patronymic // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,statusId: null == statusId ? _self.statusId : statusId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetReferenceModel].
extension GetReferenceModelPatterns on GetReferenceModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetReferenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetReferenceModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetReferenceModel value)  $default,){
final _that = this;
switch (_that) {
case _GetReferenceModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetReferenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetReferenceModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  String firstname,  String lastname,  String patronymic,  String group,  int typeId,  int statusId,  int quantity,  String date,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetReferenceModel() when $default != null:
return $default(_that.id,_that.userId,_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.typeId,_that.statusId,_that.quantity,_that.date,_that.phone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  String firstname,  String lastname,  String patronymic,  String group,  int typeId,  int statusId,  int quantity,  String date,  String phone)  $default,) {final _that = this;
switch (_that) {
case _GetReferenceModel():
return $default(_that.id,_that.userId,_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.typeId,_that.statusId,_that.quantity,_that.date,_that.phone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  String firstname,  String lastname,  String patronymic,  String group,  int typeId,  int statusId,  int quantity,  String date,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _GetReferenceModel() when $default != null:
return $default(_that.id,_that.userId,_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.typeId,_that.statusId,_that.quantity,_that.date,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetReferenceModel implements GetReferenceModel {
   _GetReferenceModel({required this.id, required this.userId, required this.firstname, required this.lastname, required this.patronymic, required this.group, required this.typeId, required this.statusId, required this.quantity, required this.date, required this.phone});
  factory _GetReferenceModel.fromJson(Map<String, dynamic> json) => _$GetReferenceModelFromJson(json);

@override final  int id;
@override final  int userId;
@override final  String firstname;
@override final  String lastname;
@override final  String patronymic;
@override final  String group;
@override final  int typeId;
@override final  int statusId;
@override final  int quantity;
@override final  String date;
@override final  String phone;

/// Create a copy of GetReferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetReferenceModelCopyWith<_GetReferenceModel> get copyWith => __$GetReferenceModelCopyWithImpl<_GetReferenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetReferenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetReferenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.patronymic, patronymic) || other.patronymic == patronymic)&&(identical(other.group, group) || other.group == group)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.statusId, statusId) || other.statusId == statusId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.date, date) || other.date == date)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,firstname,lastname,patronymic,group,typeId,statusId,quantity,date,phone);

@override
String toString() {
  return 'GetReferenceModel(id: $id, userId: $userId, firstname: $firstname, lastname: $lastname, patronymic: $patronymic, group: $group, typeId: $typeId, statusId: $statusId, quantity: $quantity, date: $date, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$GetReferenceModelCopyWith<$Res> implements $GetReferenceModelCopyWith<$Res> {
  factory _$GetReferenceModelCopyWith(_GetReferenceModel value, $Res Function(_GetReferenceModel) _then) = __$GetReferenceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, String firstname, String lastname, String patronymic, String group, int typeId, int statusId, int quantity, String date, String phone
});




}
/// @nodoc
class __$GetReferenceModelCopyWithImpl<$Res>
    implements _$GetReferenceModelCopyWith<$Res> {
  __$GetReferenceModelCopyWithImpl(this._self, this._then);

  final _GetReferenceModel _self;
  final $Res Function(_GetReferenceModel) _then;

/// Create a copy of GetReferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? firstname = null,Object? lastname = null,Object? patronymic = null,Object? group = null,Object? typeId = null,Object? statusId = null,Object? quantity = null,Object? date = null,Object? phone = null,}) {
  return _then(_GetReferenceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,patronymic: null == patronymic ? _self.patronymic : patronymic // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,statusId: null == statusId ? _self.statusId : statusId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
