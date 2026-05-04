// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetWorthSnapshot {

 String get id;// YYYY-MM
 String get uid; double get totalAssets; double get totalLiabilities; double get netWorth; DateTime get capturedAt;
/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetWorthSnapshotCopyWith<NetWorthSnapshot> get copyWith => _$NetWorthSnapshotCopyWithImpl<NetWorthSnapshot>(this as NetWorthSnapshot, _$identity);

  /// Serializes this NetWorthSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetWorthSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,totalAssets,totalLiabilities,netWorth,capturedAt);

@override
String toString() {
  return 'NetWorthSnapshot(id: $id, uid: $uid, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class $NetWorthSnapshotCopyWith<$Res>  {
  factory $NetWorthSnapshotCopyWith(NetWorthSnapshot value, $Res Function(NetWorthSnapshot) _then) = _$NetWorthSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String uid, double totalAssets, double totalLiabilities, double netWorth, DateTime capturedAt
});




}
/// @nodoc
class _$NetWorthSnapshotCopyWithImpl<$Res>
    implements $NetWorthSnapshotCopyWith<$Res> {
  _$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final NetWorthSnapshot _self;
  final $Res Function(NetWorthSnapshot) _then;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? capturedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as double,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as double,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as double,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NetWorthSnapshot].
extension NetWorthSnapshotPatterns on NetWorthSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetWorthSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetWorthSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _NetWorthSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetWorthSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  double totalAssets,  double totalLiabilities,  double netWorth,  DateTime capturedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
return $default(_that.id,_that.uid,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.capturedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  double totalAssets,  double totalLiabilities,  double netWorth,  DateTime capturedAt)  $default,) {final _that = this;
switch (_that) {
case _NetWorthSnapshot():
return $default(_that.id,_that.uid,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.capturedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  double totalAssets,  double totalLiabilities,  double netWorth,  DateTime capturedAt)?  $default,) {final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
return $default(_that.id,_that.uid,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.capturedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetWorthSnapshot implements NetWorthSnapshot {
  const _NetWorthSnapshot({required this.id, required this.uid, required this.totalAssets, required this.totalLiabilities, required this.netWorth, required this.capturedAt});
  factory _NetWorthSnapshot.fromJson(Map<String, dynamic> json) => _$NetWorthSnapshotFromJson(json);

@override final  String id;
// YYYY-MM
@override final  String uid;
@override final  double totalAssets;
@override final  double totalLiabilities;
@override final  double netWorth;
@override final  DateTime capturedAt;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetWorthSnapshotCopyWith<_NetWorthSnapshot> get copyWith => __$NetWorthSnapshotCopyWithImpl<_NetWorthSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetWorthSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetWorthSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,totalAssets,totalLiabilities,netWorth,capturedAt);

@override
String toString() {
  return 'NetWorthSnapshot(id: $id, uid: $uid, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class _$NetWorthSnapshotCopyWith<$Res> implements $NetWorthSnapshotCopyWith<$Res> {
  factory _$NetWorthSnapshotCopyWith(_NetWorthSnapshot value, $Res Function(_NetWorthSnapshot) _then) = __$NetWorthSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, double totalAssets, double totalLiabilities, double netWorth, DateTime capturedAt
});




}
/// @nodoc
class __$NetWorthSnapshotCopyWithImpl<$Res>
    implements _$NetWorthSnapshotCopyWith<$Res> {
  __$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final _NetWorthSnapshot _self;
  final $Res Function(_NetWorthSnapshot) _then;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? capturedAt = null,}) {
  return _then(_NetWorthSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as double,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as double,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as double,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
