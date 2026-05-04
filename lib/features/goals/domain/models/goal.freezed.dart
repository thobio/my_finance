// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Goal {

 String get id; String get uid; String get name; double get targetAmount; DateTime get targetDate; DateTime get startDate; double get currentSaved; double get monthlyContribution; int get priority; GoalStatus get status; GoalType get type;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.currentSaved, currentSaved) || other.currentSaved == currentSaved)&&(identical(other.monthlyContribution, monthlyContribution) || other.monthlyContribution == monthlyContribution)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,name,targetAmount,targetDate,startDate,currentSaved,monthlyContribution,priority,status,type);

@override
String toString() {
  return 'Goal(id: $id, uid: $uid, name: $name, targetAmount: $targetAmount, targetDate: $targetDate, startDate: $startDate, currentSaved: $currentSaved, monthlyContribution: $monthlyContribution, priority: $priority, status: $status, type: $type)';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
 String id, String uid, String name, double targetAmount, DateTime targetDate, DateTime startDate, double currentSaved, double monthlyContribution, int priority, GoalStatus status, GoalType type
});




}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? name = null,Object? targetAmount = null,Object? targetDate = null,Object? startDate = null,Object? currentSaved = null,Object? monthlyContribution = null,Object? priority = null,Object? status = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as double,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentSaved: null == currentSaved ? _self.currentSaved : currentSaved // ignore: cast_nullable_to_non_nullable
as double,monthlyContribution: null == monthlyContribution ? _self.monthlyContribution : monthlyContribution // ignore: cast_nullable_to_non_nullable
as double,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GoalType,
  ));
}

}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Goal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Goal value)  $default,){
final _that = this;
switch (_that) {
case _Goal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Goal value)?  $default,){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  String name,  double targetAmount,  DateTime targetDate,  DateTime startDate,  double currentSaved,  double monthlyContribution,  int priority,  GoalStatus status,  GoalType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.uid,_that.name,_that.targetAmount,_that.targetDate,_that.startDate,_that.currentSaved,_that.monthlyContribution,_that.priority,_that.status,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  String name,  double targetAmount,  DateTime targetDate,  DateTime startDate,  double currentSaved,  double monthlyContribution,  int priority,  GoalStatus status,  GoalType type)  $default,) {final _that = this;
switch (_that) {
case _Goal():
return $default(_that.id,_that.uid,_that.name,_that.targetAmount,_that.targetDate,_that.startDate,_that.currentSaved,_that.monthlyContribution,_that.priority,_that.status,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  String name,  double targetAmount,  DateTime targetDate,  DateTime startDate,  double currentSaved,  double monthlyContribution,  int priority,  GoalStatus status,  GoalType type)?  $default,) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.uid,_that.name,_that.targetAmount,_that.targetDate,_that.startDate,_that.currentSaved,_that.monthlyContribution,_that.priority,_that.status,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Goal implements Goal {
  const _Goal({required this.id, required this.uid, required this.name, required this.targetAmount, required this.targetDate, required this.startDate, this.currentSaved = 0.0, this.monthlyContribution = 0.0, this.priority = 1, this.status = GoalStatus.active, this.type = GoalType.standard});
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

@override final  String id;
@override final  String uid;
@override final  String name;
@override final  double targetAmount;
@override final  DateTime targetDate;
@override final  DateTime startDate;
@override@JsonKey() final  double currentSaved;
@override@JsonKey() final  double monthlyContribution;
@override@JsonKey() final  int priority;
@override@JsonKey() final  GoalStatus status;
@override@JsonKey() final  GoalType type;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCopyWith<_Goal> get copyWith => __$GoalCopyWithImpl<_Goal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.currentSaved, currentSaved) || other.currentSaved == currentSaved)&&(identical(other.monthlyContribution, monthlyContribution) || other.monthlyContribution == monthlyContribution)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,name,targetAmount,targetDate,startDate,currentSaved,monthlyContribution,priority,status,type);

@override
String toString() {
  return 'Goal(id: $id, uid: $uid, name: $name, targetAmount: $targetAmount, targetDate: $targetDate, startDate: $startDate, currentSaved: $currentSaved, monthlyContribution: $monthlyContribution, priority: $priority, status: $status, type: $type)';
}


}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) = __$GoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, String name, double targetAmount, DateTime targetDate, DateTime startDate, double currentSaved, double monthlyContribution, int priority, GoalStatus status, GoalType type
});




}
/// @nodoc
class __$GoalCopyWithImpl<$Res>
    implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? name = null,Object? targetAmount = null,Object? targetDate = null,Object? startDate = null,Object? currentSaved = null,Object? monthlyContribution = null,Object? priority = null,Object? status = null,Object? type = null,}) {
  return _then(_Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as double,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentSaved: null == currentSaved ? _self.currentSaved : currentSaved // ignore: cast_nullable_to_non_nullable
as double,monthlyContribution: null == monthlyContribution ? _self.monthlyContribution : monthlyContribution // ignore: cast_nullable_to_non_nullable
as double,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GoalType,
  ));
}


}

// dart format on
