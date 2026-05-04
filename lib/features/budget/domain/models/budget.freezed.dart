// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {

 String get id; String get uid; int get year; double get totalProjectedIncome;/// Fixed monthly obligations: e.g. {"Rent": 15000.0, "EMI": 20000.0}
 Map<String, double> get fixedObligations;/// Monthly category allocations: e.g. {"Food": 6000.0, "Travel": 2400.0}
 Map<String, double> get monthlyAllocations;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalProjectedIncome, totalProjectedIncome) || other.totalProjectedIncome == totalProjectedIncome)&&const DeepCollectionEquality().equals(other.fixedObligations, fixedObligations)&&const DeepCollectionEquality().equals(other.monthlyAllocations, monthlyAllocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,year,totalProjectedIncome,const DeepCollectionEquality().hash(fixedObligations),const DeepCollectionEquality().hash(monthlyAllocations));

@override
String toString() {
  return 'Budget(id: $id, uid: $uid, year: $year, totalProjectedIncome: $totalProjectedIncome, fixedObligations: $fixedObligations, monthlyAllocations: $monthlyAllocations)';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 String id, String uid, int year, double totalProjectedIncome, Map<String, double> fixedObligations, Map<String, double> monthlyAllocations
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? year = null,Object? totalProjectedIncome = null,Object? fixedObligations = null,Object? monthlyAllocations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalProjectedIncome: null == totalProjectedIncome ? _self.totalProjectedIncome : totalProjectedIncome // ignore: cast_nullable_to_non_nullable
as double,fixedObligations: null == fixedObligations ? _self.fixedObligations : fixedObligations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,monthlyAllocations: null == monthlyAllocations ? _self.monthlyAllocations : monthlyAllocations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uid,  int year,  double totalProjectedIncome,  Map<String, double> fixedObligations,  Map<String, double> monthlyAllocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.uid,_that.year,_that.totalProjectedIncome,_that.fixedObligations,_that.monthlyAllocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uid,  int year,  double totalProjectedIncome,  Map<String, double> fixedObligations,  Map<String, double> monthlyAllocations)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.id,_that.uid,_that.year,_that.totalProjectedIncome,_that.fixedObligations,_that.monthlyAllocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uid,  int year,  double totalProjectedIncome,  Map<String, double> fixedObligations,  Map<String, double> monthlyAllocations)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.uid,_that.year,_that.totalProjectedIncome,_that.fixedObligations,_that.monthlyAllocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Budget implements Budget {
  const _Budget({required this.id, required this.uid, required this.year, this.totalProjectedIncome = 0.0, final  Map<String, double> fixedObligations = const {}, final  Map<String, double> monthlyAllocations = const {}}): _fixedObligations = fixedObligations,_monthlyAllocations = monthlyAllocations;
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

@override final  String id;
@override final  String uid;
@override final  int year;
@override@JsonKey() final  double totalProjectedIncome;
/// Fixed monthly obligations: e.g. {"Rent": 15000.0, "EMI": 20000.0}
 final  Map<String, double> _fixedObligations;
/// Fixed monthly obligations: e.g. {"Rent": 15000.0, "EMI": 20000.0}
@override@JsonKey() Map<String, double> get fixedObligations {
  if (_fixedObligations is EqualUnmodifiableMapView) return _fixedObligations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fixedObligations);
}

/// Monthly category allocations: e.g. {"Food": 6000.0, "Travel": 2400.0}
 final  Map<String, double> _monthlyAllocations;
/// Monthly category allocations: e.g. {"Food": 6000.0, "Travel": 2400.0}
@override@JsonKey() Map<String, double> get monthlyAllocations {
  if (_monthlyAllocations is EqualUnmodifiableMapView) return _monthlyAllocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monthlyAllocations);
}


/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalProjectedIncome, totalProjectedIncome) || other.totalProjectedIncome == totalProjectedIncome)&&const DeepCollectionEquality().equals(other._fixedObligations, _fixedObligations)&&const DeepCollectionEquality().equals(other._monthlyAllocations, _monthlyAllocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,year,totalProjectedIncome,const DeepCollectionEquality().hash(_fixedObligations),const DeepCollectionEquality().hash(_monthlyAllocations));

@override
String toString() {
  return 'Budget(id: $id, uid: $uid, year: $year, totalProjectedIncome: $totalProjectedIncome, fixedObligations: $fixedObligations, monthlyAllocations: $monthlyAllocations)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 String id, String uid, int year, double totalProjectedIncome, Map<String, double> fixedObligations, Map<String, double> monthlyAllocations
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? year = null,Object? totalProjectedIncome = null,Object? fixedObligations = null,Object? monthlyAllocations = null,}) {
  return _then(_Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalProjectedIncome: null == totalProjectedIncome ? _self.totalProjectedIncome : totalProjectedIncome // ignore: cast_nullable_to_non_nullable
as double,fixedObligations: null == fixedObligations ? _self._fixedObligations : fixedObligations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,monthlyAllocations: null == monthlyAllocations ? _self._monthlyAllocations : monthlyAllocations // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
