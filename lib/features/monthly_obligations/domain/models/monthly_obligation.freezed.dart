// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_obligation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyObligation {

 String get id; String get uid; String get label; double get amount; int get year; int get month; int get dueDay; ObligationPriority get priority; bool get isPaid; String get notes; String? get paidTransactionId;
/// Create a copy of MonthlyObligation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyObligationCopyWith<MonthlyObligation> get copyWith => _$MonthlyObligationCopyWithImpl<MonthlyObligation>(this as MonthlyObligation, _$identity);

  /// Serializes this MonthlyObligation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyObligation&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidTransactionId, paidTransactionId) || other.paidTransactionId == paidTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,amount,year,month,dueDay,priority,isPaid,notes,paidTransactionId);

@override
String toString() {
  return 'MonthlyObligation(id: $id, uid: $uid, label: $label, amount: $amount, year: $year, month: $month, dueDay: $dueDay, priority: $priority, isPaid: $isPaid, notes: $notes, paidTransactionId: $paidTransactionId)';
}


}

/// @nodoc
abstract mixin class $MonthlyObligationCopyWith<$Res>  {
  factory $MonthlyObligationCopyWith(MonthlyObligation value, $Res Function(MonthlyObligation) _then) = _$MonthlyObligationCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String label, double amount, int year, int month, int dueDay, ObligationPriority priority, bool isPaid, String notes, String? paidTransactionId
});




}
/// @nodoc
class _$MonthlyObligationCopyWithImpl<$Res>
    implements $MonthlyObligationCopyWith<$Res> {
  _$MonthlyObligationCopyWithImpl(this._self, this._then);

  final MonthlyObligation _self;
  final $Res Function(MonthlyObligation) _then;

/// Create a copy of MonthlyObligation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? amount = null,Object? year = null,Object? month = null,Object? dueDay = null,Object? priority = null,Object? isPaid = null,Object? notes = null,Object? paidTransactionId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ObligationPriority,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,paidTransactionId: freezed == paidTransactionId ? _self.paidTransactionId : paidTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyObligation].
extension MonthlyObligationPatterns on MonthlyObligation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyObligation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyObligation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyObligation value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyObligation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyObligation value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyObligation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  double amount,  int year,  int month,  int dueDay,  ObligationPriority priority,  bool isPaid,  String notes,  String? paidTransactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyObligation() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.year,_that.month,_that.dueDay,_that.priority,_that.isPaid,_that.notes,_that.paidTransactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  double amount,  int year,  int month,  int dueDay,  ObligationPriority priority,  bool isPaid,  String notes,  String? paidTransactionId)  $default,) {final _that = this;
switch (_that) {
case _MonthlyObligation():
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.year,_that.month,_that.dueDay,_that.priority,_that.isPaid,_that.notes,_that.paidTransactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String label,  double amount,  int year,  int month,  int dueDay,  ObligationPriority priority,  bool isPaid,  String notes,  String? paidTransactionId)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyObligation() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.year,_that.month,_that.dueDay,_that.priority,_that.isPaid,_that.notes,_that.paidTransactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyObligation implements MonthlyObligation {
  const _MonthlyObligation({required this.id, required this.uid, required this.label, required this.amount, required this.year, required this.month, this.dueDay = 1, this.priority = ObligationPriority.medium, this.isPaid = false, this.notes = '', this.paidTransactionId});
  factory _MonthlyObligation.fromJson(Map<String, dynamic> json) => _$MonthlyObligationFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String label;
@override final  double amount;
@override final  int year;
@override final  int month;
@override@JsonKey() final  int dueDay;
@override@JsonKey() final  ObligationPriority priority;
@override@JsonKey() final  bool isPaid;
@override@JsonKey() final  String notes;
@override final  String? paidTransactionId;

/// Create a copy of MonthlyObligation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyObligationCopyWith<_MonthlyObligation> get copyWith => __$MonthlyObligationCopyWithImpl<_MonthlyObligation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyObligationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyObligation&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidTransactionId, paidTransactionId) || other.paidTransactionId == paidTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,amount,year,month,dueDay,priority,isPaid,notes,paidTransactionId);

@override
String toString() {
  return 'MonthlyObligation(id: $id, uid: $uid, label: $label, amount: $amount, year: $year, month: $month, dueDay: $dueDay, priority: $priority, isPaid: $isPaid, notes: $notes, paidTransactionId: $paidTransactionId)';
}


}

/// @nodoc
abstract mixin class _$MonthlyObligationCopyWith<$Res> implements $MonthlyObligationCopyWith<$Res> {
  factory _$MonthlyObligationCopyWith(_MonthlyObligation value, $Res Function(_MonthlyObligation) _then) = __$MonthlyObligationCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String label, double amount, int year, int month, int dueDay, ObligationPriority priority, bool isPaid, String notes, String? paidTransactionId
});




}
/// @nodoc
class __$MonthlyObligationCopyWithImpl<$Res>
    implements _$MonthlyObligationCopyWith<$Res> {
  __$MonthlyObligationCopyWithImpl(this._self, this._then);

  final _MonthlyObligation _self;
  final $Res Function(_MonthlyObligation) _then;

/// Create a copy of MonthlyObligation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? amount = null,Object? year = null,Object? month = null,Object? dueDay = null,Object? priority = null,Object? isPaid = null,Object? notes = null,Object? paidTransactionId = freezed,}) {
  return _then(_MonthlyObligation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ObligationPriority,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,paidTransactionId: freezed == paidTransactionId ? _self.paidTransactionId : paidTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
