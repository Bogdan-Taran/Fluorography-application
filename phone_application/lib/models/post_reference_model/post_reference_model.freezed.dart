// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostReferenceModel {

 String get firstname; String get lastname; String get patronymic; String get group; int get type_id; String get phone; int get quantity;
/// Create a copy of PostReferenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostReferenceModelCopyWith<PostReferenceModel> get copyWith => _$PostReferenceModelCopyWithImpl<PostReferenceModel>(this as PostReferenceModel, _$identity);

  /// Serializes this PostReferenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostReferenceModel&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.patronymic, patronymic) || other.patronymic == patronymic)&&(identical(other.group, group) || other.group == group)&&(identical(other.type_id, type_id) || other.type_id == type_id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstname,lastname,patronymic,group,type_id,phone,quantity);

@override
String toString() {
  return 'PostReferenceModel(firstname: $firstname, lastname: $lastname, patronymic: $patronymic, group: $group, type_id: $type_id, phone: $phone, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $PostReferenceModelCopyWith<$Res>  {
  factory $PostReferenceModelCopyWith(PostReferenceModel value, $Res Function(PostReferenceModel) _then) = _$PostReferenceModelCopyWithImpl;
@useResult
$Res call({
 String firstname, String lastname, String patronymic, String group, int type_id, String phone, int quantity
});




}
/// @nodoc
class _$PostReferenceModelCopyWithImpl<$Res>
    implements $PostReferenceModelCopyWith<$Res> {
  _$PostReferenceModelCopyWithImpl(this._self, this._then);

  final PostReferenceModel _self;
  final $Res Function(PostReferenceModel) _then;

/// Create a copy of PostReferenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstname = null,Object? lastname = null,Object? patronymic = null,Object? group = null,Object? type_id = null,Object? phone = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,patronymic: null == patronymic ? _self.patronymic : patronymic // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,type_id: null == type_id ? _self.type_id : type_id // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostReferenceModel].
extension PostReferenceModelPatterns on PostReferenceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostReferenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostReferenceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostReferenceModel value)  $default,){
final _that = this;
switch (_that) {
case _PostReferenceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostReferenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostReferenceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstname,  String lastname,  String patronymic,  String group,  int type_id,  String phone,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostReferenceModel() when $default != null:
return $default(_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.type_id,_that.phone,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstname,  String lastname,  String patronymic,  String group,  int type_id,  String phone,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _PostReferenceModel():
return $default(_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.type_id,_that.phone,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstname,  String lastname,  String patronymic,  String group,  int type_id,  String phone,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _PostReferenceModel() when $default != null:
return $default(_that.firstname,_that.lastname,_that.patronymic,_that.group,_that.type_id,_that.phone,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostReferenceModel implements PostReferenceModel {
   _PostReferenceModel({required this.firstname, required this.lastname, required this.patronymic, required this.group, required this.type_id, required this.phone, required this.quantity});
  factory _PostReferenceModel.fromJson(Map<String, dynamic> json) => _$PostReferenceModelFromJson(json);

@override final  String firstname;
@override final  String lastname;
@override final  String patronymic;
@override final  String group;
@override final  int type_id;
@override final  String phone;
@override final  int quantity;

/// Create a copy of PostReferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostReferenceModelCopyWith<_PostReferenceModel> get copyWith => __$PostReferenceModelCopyWithImpl<_PostReferenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostReferenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostReferenceModel&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.patronymic, patronymic) || other.patronymic == patronymic)&&(identical(other.group, group) || other.group == group)&&(identical(other.type_id, type_id) || other.type_id == type_id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstname,lastname,patronymic,group,type_id,phone,quantity);

@override
String toString() {
  return 'PostReferenceModel(firstname: $firstname, lastname: $lastname, patronymic: $patronymic, group: $group, type_id: $type_id, phone: $phone, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$PostReferenceModelCopyWith<$Res> implements $PostReferenceModelCopyWith<$Res> {
  factory _$PostReferenceModelCopyWith(_PostReferenceModel value, $Res Function(_PostReferenceModel) _then) = __$PostReferenceModelCopyWithImpl;
@override @useResult
$Res call({
 String firstname, String lastname, String patronymic, String group, int type_id, String phone, int quantity
});




}
/// @nodoc
class __$PostReferenceModelCopyWithImpl<$Res>
    implements _$PostReferenceModelCopyWith<$Res> {
  __$PostReferenceModelCopyWithImpl(this._self, this._then);

  final _PostReferenceModel _self;
  final $Res Function(_PostReferenceModel) _then;

/// Create a copy of PostReferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstname = null,Object? lastname = null,Object? patronymic = null,Object? group = null,Object? type_id = null,Object? phone = null,Object? quantity = null,}) {
  return _then(_PostReferenceModel(
firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,patronymic: null == patronymic ? _self.patronymic : patronymic // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,type_id: null == type_id ? _self.type_id : type_id // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
