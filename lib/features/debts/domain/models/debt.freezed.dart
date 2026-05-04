// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Debt {

 String get id; String get uid; String get label; DebtType get type; double get outstanding; double get interestRatePercent; double get minimumPayment; int get dueDay; String? get linkedAccountId; double? get creditLimit;
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCopyWith<Debt> get copyWith => _$DebtCopyWithImpl<Debt>(this as Debt, _$identity);

  /// Serializes this Debt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.interestRatePercent, interestRatePercent) || other.interestRatePercent == interestRatePercent)&&(identical(other.minimumPayment, minimumPayment) || other.minimumPayment == minimumPayment)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,type,outstanding,interestRatePercent,minimumPayment,dueDay,linkedAccountId,creditLimit);

@override
String toString() {
  return 'Debt(id: $id, uid: $uid, label: $label, type: $type, outstanding: $outstanding, interestRatePercent: $interestRatePercent, minimumPayment: $minimumPayment, dueDay: $dueDay, linkedAccountId: $linkedAccountId, creditLimit: $creditLimit)';
}


}

/// @nodoc
abstract mixin class $DebtCopyWith<$Res>  {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) _then) = _$DebtCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String label, DebtType type, double outstanding, double interestRatePercent, double minimumPayment, int dueDay, String? linkedAccountId, double? creditLimit
});




}
/// @nodoc
class _$DebtCopyWithImpl<$Res>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._self, this._then);

  final Debt _self;
  final $Res Function(Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? type = null,Object? outstanding = null,Object? interestRatePercent = null,Object? minimumPayment = null,Object? dueDay = null,Object? linkedAccountId = freezed,Object? creditLimit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DebtType,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as double,interestRatePercent: null == interestRatePercent ? _self.interestRatePercent : interestRatePercent // ignore: cast_nullable_to_non_nullable
as double,minimumPayment: null == minimumPayment ? _self.minimumPayment : minimumPayment // ignore: cast_nullable_to_non_nullable
as double,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Debt].
extension DebtPatterns on Debt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debt value)  $default,){
final _that = this;
switch (_that) {
case _Debt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debt value)?  $default,){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  DebtType type,  double outstanding,  double interestRatePercent,  double minimumPayment,  int dueDay,  String? linkedAccountId,  double? creditLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.type,_that.outstanding,_that.interestRatePercent,_that.minimumPayment,_that.dueDay,_that.linkedAccountId,_that.creditLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  DebtType type,  double outstanding,  double interestRatePercent,  double minimumPayment,  int dueDay,  String? linkedAccountId,  double? creditLimit)  $default,) {final _that = this;
switch (_that) {
case _Debt():
return $default(_that.id,_that.uid,_that.label,_that.type,_that.outstanding,_that.interestRatePercent,_that.minimumPayment,_that.dueDay,_that.linkedAccountId,_that.creditLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String label,  DebtType type,  double outstanding,  double interestRatePercent,  double minimumPayment,  int dueDay,  String? linkedAccountId,  double? creditLimit)?  $default,) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.type,_that.outstanding,_that.interestRatePercent,_that.minimumPayment,_that.dueDay,_that.linkedAccountId,_that.creditLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Debt implements Debt {
  const _Debt({required this.id, required this.uid, required this.label, this.type = DebtType.loan, required this.outstanding, required this.interestRatePercent, required this.minimumPayment, this.dueDay = 1, this.linkedAccountId, this.creditLimit});
  factory _Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String label;
@override@JsonKey() final  DebtType type;
@override final  double outstanding;
@override final  double interestRatePercent;
@override final  double minimumPayment;
@override@JsonKey() final  int dueDay;
@override final  String? linkedAccountId;
@override final  double? creditLimit;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtCopyWith<_Debt> get copyWith => __$DebtCopyWithImpl<_Debt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.interestRatePercent, interestRatePercent) || other.interestRatePercent == interestRatePercent)&&(identical(other.minimumPayment, minimumPayment) || other.minimumPayment == minimumPayment)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,type,outstanding,interestRatePercent,minimumPayment,dueDay,linkedAccountId,creditLimit);

@override
String toString() {
  return 'Debt(id: $id, uid: $uid, label: $label, type: $type, outstanding: $outstanding, interestRatePercent: $interestRatePercent, minimumPayment: $minimumPayment, dueDay: $dueDay, linkedAccountId: $linkedAccountId, creditLimit: $creditLimit)';
}


}

/// @nodoc
abstract mixin class _$DebtCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$DebtCopyWith(_Debt value, $Res Function(_Debt) _then) = __$DebtCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String label, DebtType type, double outstanding, double interestRatePercent, double minimumPayment, int dueDay, String? linkedAccountId, double? creditLimit
});




}
/// @nodoc
class __$DebtCopyWithImpl<$Res>
    implements _$DebtCopyWith<$Res> {
  __$DebtCopyWithImpl(this._self, this._then);

  final _Debt _self;
  final $Res Function(_Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? type = null,Object? outstanding = null,Object? interestRatePercent = null,Object? minimumPayment = null,Object? dueDay = null,Object? linkedAccountId = freezed,Object? creditLimit = freezed,}) {
  return _then(_Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DebtType,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as double,interestRatePercent: null == interestRatePercent ? _self.interestRatePercent : interestRatePercent // ignore: cast_nullable_to_non_nullable
as double,minimumPayment: null == minimumPayment ? _self.minimumPayment : minimumPayment // ignore: cast_nullable_to_non_nullable
as double,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
