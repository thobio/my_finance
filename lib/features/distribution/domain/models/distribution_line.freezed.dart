// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distribution_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DistributionLine {

 String get label; double get amount; DistributionLineType get type; String? get goalId; String? get categoryId;
/// Create a copy of DistributionLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionLineCopyWith<DistributionLine> get copyWith => _$DistributionLineCopyWithImpl<DistributionLine>(this as DistributionLine, _$identity);

  /// Serializes this DistributionLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount,type,goalId,categoryId);

@override
String toString() {
  return 'DistributionLine(label: $label, amount: $amount, type: $type, goalId: $goalId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $DistributionLineCopyWith<$Res>  {
  factory $DistributionLineCopyWith(DistributionLine value, $Res Function(DistributionLine) _then) = _$DistributionLineCopyWithImpl;
@useResult
$Res call({
 String label, double amount, DistributionLineType type, String? goalId, String? categoryId
});




}
/// @nodoc
class _$DistributionLineCopyWithImpl<$Res>
    implements $DistributionLineCopyWith<$Res> {
  _$DistributionLineCopyWithImpl(this._self, this._then);

  final DistributionLine _self;
  final $Res Function(DistributionLine) _then;

/// Create a copy of DistributionLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? amount = null,Object? type = null,Object? goalId = freezed,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DistributionLineType,goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionLine].
extension DistributionLinePatterns on DistributionLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionLine value)  $default,){
final _that = this;
switch (_that) {
case _DistributionLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionLine value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double amount,  DistributionLineType type,  String? goalId,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionLine() when $default != null:
return $default(_that.label,_that.amount,_that.type,_that.goalId,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double amount,  DistributionLineType type,  String? goalId,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _DistributionLine():
return $default(_that.label,_that.amount,_that.type,_that.goalId,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double amount,  DistributionLineType type,  String? goalId,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _DistributionLine() when $default != null:
return $default(_that.label,_that.amount,_that.type,_that.goalId,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionLine implements DistributionLine {
  const _DistributionLine({required this.label, required this.amount, required this.type, this.goalId, this.categoryId});
  factory _DistributionLine.fromJson(Map<String, dynamic> json) => _$DistributionLineFromJson(json);

@override final  String label;
@override final  double amount;
@override final  DistributionLineType type;
@override final  String? goalId;
@override final  String? categoryId;

/// Create a copy of DistributionLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionLineCopyWith<_DistributionLine> get copyWith => __$DistributionLineCopyWithImpl<_DistributionLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount,type,goalId,categoryId);

@override
String toString() {
  return 'DistributionLine(label: $label, amount: $amount, type: $type, goalId: $goalId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$DistributionLineCopyWith<$Res> implements $DistributionLineCopyWith<$Res> {
  factory _$DistributionLineCopyWith(_DistributionLine value, $Res Function(_DistributionLine) _then) = __$DistributionLineCopyWithImpl;
@override @useResult
$Res call({
 String label, double amount, DistributionLineType type, String? goalId, String? categoryId
});




}
/// @nodoc
class __$DistributionLineCopyWithImpl<$Res>
    implements _$DistributionLineCopyWith<$Res> {
  __$DistributionLineCopyWithImpl(this._self, this._then);

  final _DistributionLine _self;
  final $Res Function(_DistributionLine) _then;

/// Create a copy of DistributionLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? amount = null,Object? type = null,Object? goalId = freezed,Object? categoryId = freezed,}) {
  return _then(_DistributionLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DistributionLineType,goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
