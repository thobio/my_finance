// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishItem {

 String get id; String get uid; String get name; double get estimatedCost; DateTime get desiredMonth; String? get linkedGoalId; WishItemStatus get status; DateTime get createdAt;
/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishItemCopyWith<WishItem> get copyWith => _$WishItemCopyWithImpl<WishItem>(this as WishItem, _$identity);

  /// Serializes this WishItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost)&&(identical(other.desiredMonth, desiredMonth) || other.desiredMonth == desiredMonth)&&(identical(other.linkedGoalId, linkedGoalId) || other.linkedGoalId == linkedGoalId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,name,estimatedCost,desiredMonth,linkedGoalId,status,createdAt);

@override
String toString() {
  return 'WishItem(id: $id, uid: $uid, name: $name, estimatedCost: $estimatedCost, desiredMonth: $desiredMonth, linkedGoalId: $linkedGoalId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WishItemCopyWith<$Res>  {
  factory $WishItemCopyWith(WishItem value, $Res Function(WishItem) _then) = _$WishItemCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String name, double estimatedCost, DateTime desiredMonth, String? linkedGoalId, WishItemStatus status, DateTime createdAt
});




}
/// @nodoc
class _$WishItemCopyWithImpl<$Res>
    implements $WishItemCopyWith<$Res> {
  _$WishItemCopyWithImpl(this._self, this._then);

  final WishItem _self;
  final $Res Function(WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? name = null,Object? estimatedCost = null,Object? desiredMonth = null,Object? linkedGoalId = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,desiredMonth: null == desiredMonth ? _self.desiredMonth : desiredMonth // ignore: cast_nullable_to_non_nullable
as DateTime,linkedGoalId: freezed == linkedGoalId ? _self.linkedGoalId : linkedGoalId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WishItemStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WishItem].
extension WishItemPatterns on WishItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishItem value)  $default,){
final _that = this;
switch (_that) {
case _WishItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishItem value)?  $default,){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String name,  double estimatedCost,  DateTime desiredMonth,  String? linkedGoalId,  WishItemStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.uid,_that.name,_that.estimatedCost,_that.desiredMonth,_that.linkedGoalId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String name,  double estimatedCost,  DateTime desiredMonth,  String? linkedGoalId,  WishItemStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WishItem():
return $default(_that.id,_that.uid,_that.name,_that.estimatedCost,_that.desiredMonth,_that.linkedGoalId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String name,  double estimatedCost,  DateTime desiredMonth,  String? linkedGoalId,  WishItemStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.uid,_that.name,_that.estimatedCost,_that.desiredMonth,_that.linkedGoalId,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishItem implements WishItem {
  const _WishItem({required this.id, required this.uid, required this.name, required this.estimatedCost, required this.desiredMonth, this.linkedGoalId, this.status = WishItemStatus.pending, required this.createdAt});
  factory _WishItem.fromJson(Map<String, dynamic> json) => _$WishItemFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String name;
@override final  double estimatedCost;
@override final  DateTime desiredMonth;
@override final  String? linkedGoalId;
@override@JsonKey() final  WishItemStatus status;
@override final  DateTime createdAt;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishItemCopyWith<_WishItem> get copyWith => __$WishItemCopyWithImpl<_WishItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost)&&(identical(other.desiredMonth, desiredMonth) || other.desiredMonth == desiredMonth)&&(identical(other.linkedGoalId, linkedGoalId) || other.linkedGoalId == linkedGoalId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,name,estimatedCost,desiredMonth,linkedGoalId,status,createdAt);

@override
String toString() {
  return 'WishItem(id: $id, uid: $uid, name: $name, estimatedCost: $estimatedCost, desiredMonth: $desiredMonth, linkedGoalId: $linkedGoalId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WishItemCopyWith<$Res> implements $WishItemCopyWith<$Res> {
  factory _$WishItemCopyWith(_WishItem value, $Res Function(_WishItem) _then) = __$WishItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String name, double estimatedCost, DateTime desiredMonth, String? linkedGoalId, WishItemStatus status, DateTime createdAt
});




}
/// @nodoc
class __$WishItemCopyWithImpl<$Res>
    implements _$WishItemCopyWith<$Res> {
  __$WishItemCopyWithImpl(this._self, this._then);

  final _WishItem _self;
  final $Res Function(_WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? name = null,Object? estimatedCost = null,Object? desiredMonth = null,Object? linkedGoalId = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_WishItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,desiredMonth: null == desiredMonth ? _self.desiredMonth : desiredMonth // ignore: cast_nullable_to_non_nullable
as DateTime,linkedGoalId: freezed == linkedGoalId ? _self.linkedGoalId : linkedGoalId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WishItemStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
