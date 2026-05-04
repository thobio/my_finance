// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distribution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Distribution {

 String get id; String get uid; String get sourceTransactionId; double get income; List<DistributionLine> get lines; bool get accepted;
/// Create a copy of Distribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionCopyWith<Distribution> get copyWith => _$DistributionCopyWithImpl<Distribution>(this as Distribution, _$identity);

  /// Serializes this Distribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Distribution&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.sourceTransactionId, sourceTransactionId) || other.sourceTransactionId == sourceTransactionId)&&(identical(other.income, income) || other.income == income)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,sourceTransactionId,income,const DeepCollectionEquality().hash(lines),accepted);

@override
String toString() {
  return 'Distribution(id: $id, uid: $uid, sourceTransactionId: $sourceTransactionId, income: $income, lines: $lines, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class $DistributionCopyWith<$Res>  {
  factory $DistributionCopyWith(Distribution value, $Res Function(Distribution) _then) = _$DistributionCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String sourceTransactionId, double income, List<DistributionLine> lines, bool accepted
});




}
/// @nodoc
class _$DistributionCopyWithImpl<$Res>
    implements $DistributionCopyWith<$Res> {
  _$DistributionCopyWithImpl(this._self, this._then);

  final Distribution _self;
  final $Res Function(Distribution) _then;

/// Create a copy of Distribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? sourceTransactionId = null,Object? income = null,Object? lines = null,Object? accepted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,sourceTransactionId: null == sourceTransactionId ? _self.sourceTransactionId : sourceTransactionId // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<DistributionLine>,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Distribution].
extension DistributionPatterns on Distribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Distribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Distribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Distribution value)  $default,){
final _that = this;
switch (_that) {
case _Distribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Distribution value)?  $default,){
final _that = this;
switch (_that) {
case _Distribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String sourceTransactionId,  double income,  List<DistributionLine> lines,  bool accepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Distribution() when $default != null:
return $default(_that.id,_that.uid,_that.sourceTransactionId,_that.income,_that.lines,_that.accepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String sourceTransactionId,  double income,  List<DistributionLine> lines,  bool accepted)  $default,) {final _that = this;
switch (_that) {
case _Distribution():
return $default(_that.id,_that.uid,_that.sourceTransactionId,_that.income,_that.lines,_that.accepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String sourceTransactionId,  double income,  List<DistributionLine> lines,  bool accepted)?  $default,) {final _that = this;
switch (_that) {
case _Distribution() when $default != null:
return $default(_that.id,_that.uid,_that.sourceTransactionId,_that.income,_that.lines,_that.accepted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Distribution implements Distribution {
  const _Distribution({required this.id, required this.uid, required this.sourceTransactionId, required this.income, required final  List<DistributionLine> lines, this.accepted = false}): _lines = lines;
  factory _Distribution.fromJson(Map<String, dynamic> json) => _$DistributionFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String sourceTransactionId;
@override final  double income;
 final  List<DistributionLine> _lines;
@override List<DistributionLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  bool accepted;

/// Create a copy of Distribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionCopyWith<_Distribution> get copyWith => __$DistributionCopyWithImpl<_Distribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Distribution&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.sourceTransactionId, sourceTransactionId) || other.sourceTransactionId == sourceTransactionId)&&(identical(other.income, income) || other.income == income)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,sourceTransactionId,income,const DeepCollectionEquality().hash(_lines),accepted);

@override
String toString() {
  return 'Distribution(id: $id, uid: $uid, sourceTransactionId: $sourceTransactionId, income: $income, lines: $lines, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class _$DistributionCopyWith<$Res> implements $DistributionCopyWith<$Res> {
  factory _$DistributionCopyWith(_Distribution value, $Res Function(_Distribution) _then) = __$DistributionCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String sourceTransactionId, double income, List<DistributionLine> lines, bool accepted
});




}
/// @nodoc
class __$DistributionCopyWithImpl<$Res>
    implements _$DistributionCopyWith<$Res> {
  __$DistributionCopyWithImpl(this._self, this._then);

  final _Distribution _self;
  final $Res Function(_Distribution) _then;

/// Create a copy of Distribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? sourceTransactionId = null,Object? income = null,Object? lines = null,Object? accepted = null,}) {
  return _then(_Distribution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,sourceTransactionId: null == sourceTransactionId ? _self.sourceTransactionId : sourceTransactionId // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<DistributionLine>,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
