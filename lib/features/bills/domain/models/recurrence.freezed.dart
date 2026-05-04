// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recurrence {

 String get id; String get uid; String get label; double get amount; String get categoryId; RecurrenceFrequency get frequency;/// Day of month for monthly/quarterly/yearly (1–31).
 int get dayOfMonth; DateTime get startDate; DateTime? get endDate; DateTime get nextDueDate; DateTime? get lastPaidDate; bool get isActive; bool get autoPost; int get reminderOffsetDays;
/// Create a copy of Recurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurrenceCopyWith<Recurrence> get copyWith => _$RecurrenceCopyWithImpl<Recurrence>(this as Recurrence, _$identity);

  /// Serializes this Recurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.lastPaidDate, lastPaidDate) || other.lastPaidDate == lastPaidDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.autoPost, autoPost) || other.autoPost == autoPost)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,amount,categoryId,frequency,dayOfMonth,startDate,endDate,nextDueDate,lastPaidDate,isActive,autoPost,reminderOffsetDays);

@override
String toString() {
  return 'Recurrence(id: $id, uid: $uid, label: $label, amount: $amount, categoryId: $categoryId, frequency: $frequency, dayOfMonth: $dayOfMonth, startDate: $startDate, endDate: $endDate, nextDueDate: $nextDueDate, lastPaidDate: $lastPaidDate, isActive: $isActive, autoPost: $autoPost, reminderOffsetDays: $reminderOffsetDays)';
}


}

/// @nodoc
abstract mixin class $RecurrenceCopyWith<$Res>  {
  factory $RecurrenceCopyWith(Recurrence value, $Res Function(Recurrence) _then) = _$RecurrenceCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String label, double amount, String categoryId, RecurrenceFrequency frequency, int dayOfMonth, DateTime startDate, DateTime? endDate, DateTime nextDueDate, DateTime? lastPaidDate, bool isActive, bool autoPost, int reminderOffsetDays
});




}
/// @nodoc
class _$RecurrenceCopyWithImpl<$Res>
    implements $RecurrenceCopyWith<$Res> {
  _$RecurrenceCopyWithImpl(this._self, this._then);

  final Recurrence _self;
  final $Res Function(Recurrence) _then;

/// Create a copy of Recurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? dayOfMonth = null,Object? startDate = null,Object? endDate = freezed,Object? nextDueDate = null,Object? lastPaidDate = freezed,Object? isActive = null,Object? autoPost = null,Object? reminderOffsetDays = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastPaidDate: freezed == lastPaidDate ? _self.lastPaidDate : lastPaidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,autoPost: null == autoPost ? _self.autoPost : autoPost // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Recurrence].
extension RecurrencePatterns on Recurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recurrence value)  $default,){
final _that = this;
switch (_that) {
case _Recurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recurrence value)?  $default,){
final _that = this;
switch (_that) {
case _Recurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  double amount,  String categoryId,  RecurrenceFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime nextDueDate,  DateTime? lastPaidDate,  bool isActive,  bool autoPost,  int reminderOffsetDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recurrence() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.categoryId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.nextDueDate,_that.lastPaidDate,_that.isActive,_that.autoPost,_that.reminderOffsetDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String label,  double amount,  String categoryId,  RecurrenceFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime nextDueDate,  DateTime? lastPaidDate,  bool isActive,  bool autoPost,  int reminderOffsetDays)  $default,) {final _that = this;
switch (_that) {
case _Recurrence():
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.categoryId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.nextDueDate,_that.lastPaidDate,_that.isActive,_that.autoPost,_that.reminderOffsetDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String label,  double amount,  String categoryId,  RecurrenceFrequency frequency,  int dayOfMonth,  DateTime startDate,  DateTime? endDate,  DateTime nextDueDate,  DateTime? lastPaidDate,  bool isActive,  bool autoPost,  int reminderOffsetDays)?  $default,) {final _that = this;
switch (_that) {
case _Recurrence() when $default != null:
return $default(_that.id,_that.uid,_that.label,_that.amount,_that.categoryId,_that.frequency,_that.dayOfMonth,_that.startDate,_that.endDate,_that.nextDueDate,_that.lastPaidDate,_that.isActive,_that.autoPost,_that.reminderOffsetDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recurrence implements Recurrence {
  const _Recurrence({required this.id, required this.uid, required this.label, required this.amount, required this.categoryId, required this.frequency, this.dayOfMonth = 1, required this.startDate, this.endDate, required this.nextDueDate, this.lastPaidDate, this.isActive = true, this.autoPost = false, this.reminderOffsetDays = 0});
  factory _Recurrence.fromJson(Map<String, dynamic> json) => _$RecurrenceFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String label;
@override final  double amount;
@override final  String categoryId;
@override final  RecurrenceFrequency frequency;
/// Day of month for monthly/quarterly/yearly (1–31).
@override@JsonKey() final  int dayOfMonth;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  DateTime nextDueDate;
@override final  DateTime? lastPaidDate;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool autoPost;
@override@JsonKey() final  int reminderOffsetDays;

/// Create a copy of Recurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurrenceCopyWith<_Recurrence> get copyWith => __$RecurrenceCopyWithImpl<_Recurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.lastPaidDate, lastPaidDate) || other.lastPaidDate == lastPaidDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.autoPost, autoPost) || other.autoPost == autoPost)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,label,amount,categoryId,frequency,dayOfMonth,startDate,endDate,nextDueDate,lastPaidDate,isActive,autoPost,reminderOffsetDays);

@override
String toString() {
  return 'Recurrence(id: $id, uid: $uid, label: $label, amount: $amount, categoryId: $categoryId, frequency: $frequency, dayOfMonth: $dayOfMonth, startDate: $startDate, endDate: $endDate, nextDueDate: $nextDueDate, lastPaidDate: $lastPaidDate, isActive: $isActive, autoPost: $autoPost, reminderOffsetDays: $reminderOffsetDays)';
}


}

/// @nodoc
abstract mixin class _$RecurrenceCopyWith<$Res> implements $RecurrenceCopyWith<$Res> {
  factory _$RecurrenceCopyWith(_Recurrence value, $Res Function(_Recurrence) _then) = __$RecurrenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String label, double amount, String categoryId, RecurrenceFrequency frequency, int dayOfMonth, DateTime startDate, DateTime? endDate, DateTime nextDueDate, DateTime? lastPaidDate, bool isActive, bool autoPost, int reminderOffsetDays
});




}
/// @nodoc
class __$RecurrenceCopyWithImpl<$Res>
    implements _$RecurrenceCopyWith<$Res> {
  __$RecurrenceCopyWithImpl(this._self, this._then);

  final _Recurrence _self;
  final $Res Function(_Recurrence) _then;

/// Create a copy of Recurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? label = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? dayOfMonth = null,Object? startDate = null,Object? endDate = freezed,Object? nextDueDate = null,Object? lastPaidDate = freezed,Object? isActive = null,Object? autoPost = null,Object? reminderOffsetDays = null,}) {
  return _then(_Recurrence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastPaidDate: freezed == lastPaidDate ? _self.lastPaidDate : lastPaidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,autoPost: null == autoPost ? _self.autoPost : autoPost // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
