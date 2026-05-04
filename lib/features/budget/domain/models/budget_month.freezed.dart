// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_month.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetMonth {

 String get yearMonth; Map<String, double> get projected; Map<String, double> get actual; double get incomeProjected; double get incomeActual;
/// Create a copy of BudgetMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetMonthCopyWith<BudgetMonth> get copyWith => _$BudgetMonthCopyWithImpl<BudgetMonth>(this as BudgetMonth, _$identity);

  /// Serializes this BudgetMonth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetMonth&&(identical(other.yearMonth, yearMonth) || other.yearMonth == yearMonth)&&const DeepCollectionEquality().equals(other.projected, projected)&&const DeepCollectionEquality().equals(other.actual, actual)&&(identical(other.incomeProjected, incomeProjected) || other.incomeProjected == incomeProjected)&&(identical(other.incomeActual, incomeActual) || other.incomeActual == incomeActual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearMonth,const DeepCollectionEquality().hash(projected),const DeepCollectionEquality().hash(actual),incomeProjected,incomeActual);

@override
String toString() {
  return 'BudgetMonth(yearMonth: $yearMonth, projected: $projected, actual: $actual, incomeProjected: $incomeProjected, incomeActual: $incomeActual)';
}


}

/// @nodoc
abstract mixin class $BudgetMonthCopyWith<$Res>  {
  factory $BudgetMonthCopyWith(BudgetMonth value, $Res Function(BudgetMonth) _then) = _$BudgetMonthCopyWithImpl;
@useResult
$Res call({
 String yearMonth, Map<String, double> projected, Map<String, double> actual, double incomeProjected, double incomeActual
});




}
/// @nodoc
class _$BudgetMonthCopyWithImpl<$Res>
    implements $BudgetMonthCopyWith<$Res> {
  _$BudgetMonthCopyWithImpl(this._self, this._then);

  final BudgetMonth _self;
  final $Res Function(BudgetMonth) _then;

/// Create a copy of BudgetMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yearMonth = null,Object? projected = null,Object? actual = null,Object? incomeProjected = null,Object? incomeActual = null,}) {
  return _then(_self.copyWith(
yearMonth: null == yearMonth ? _self.yearMonth : yearMonth // ignore: cast_nullable_to_non_nullable
as String,projected: null == projected ? _self.projected : projected // ignore: cast_nullable_to_non_nullable
as Map<String, double>,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as Map<String, double>,incomeProjected: null == incomeProjected ? _self.incomeProjected : incomeProjected // ignore: cast_nullable_to_non_nullable
as double,incomeActual: null == incomeActual ? _self.incomeActual : incomeActual // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetMonth].
extension BudgetMonthPatterns on BudgetMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetMonth value)  $default,){
final _that = this;
switch (_that) {
case _BudgetMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetMonth value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String yearMonth,  Map<String, double> projected,  Map<String, double> actual,  double incomeProjected,  double incomeActual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetMonth() when $default != null:
return $default(_that.yearMonth,_that.projected,_that.actual,_that.incomeProjected,_that.incomeActual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String yearMonth,  Map<String, double> projected,  Map<String, double> actual,  double incomeProjected,  double incomeActual)  $default,) {final _that = this;
switch (_that) {
case _BudgetMonth():
return $default(_that.yearMonth,_that.projected,_that.actual,_that.incomeProjected,_that.incomeActual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String yearMonth,  Map<String, double> projected,  Map<String, double> actual,  double incomeProjected,  double incomeActual)?  $default,) {final _that = this;
switch (_that) {
case _BudgetMonth() when $default != null:
return $default(_that.yearMonth,_that.projected,_that.actual,_that.incomeProjected,_that.incomeActual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetMonth implements BudgetMonth {
  const _BudgetMonth({required this.yearMonth, final  Map<String, double> projected = const {}, final  Map<String, double> actual = const {}, this.incomeProjected = 0.0, this.incomeActual = 0.0}): _projected = projected,_actual = actual;
  factory _BudgetMonth.fromJson(Map<String, dynamic> json) => _$BudgetMonthFromJson(json);

@override final  String yearMonth;
 final  Map<String, double> _projected;
@override@JsonKey() Map<String, double> get projected {
  if (_projected is EqualUnmodifiableMapView) return _projected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_projected);
}

 final  Map<String, double> _actual;
@override@JsonKey() Map<String, double> get actual {
  if (_actual is EqualUnmodifiableMapView) return _actual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_actual);
}

@override@JsonKey() final  double incomeProjected;
@override@JsonKey() final  double incomeActual;

/// Create a copy of BudgetMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetMonthCopyWith<_BudgetMonth> get copyWith => __$BudgetMonthCopyWithImpl<_BudgetMonth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetMonthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetMonth&&(identical(other.yearMonth, yearMonth) || other.yearMonth == yearMonth)&&const DeepCollectionEquality().equals(other._projected, _projected)&&const DeepCollectionEquality().equals(other._actual, _actual)&&(identical(other.incomeProjected, incomeProjected) || other.incomeProjected == incomeProjected)&&(identical(other.incomeActual, incomeActual) || other.incomeActual == incomeActual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearMonth,const DeepCollectionEquality().hash(_projected),const DeepCollectionEquality().hash(_actual),incomeProjected,incomeActual);

@override
String toString() {
  return 'BudgetMonth(yearMonth: $yearMonth, projected: $projected, actual: $actual, incomeProjected: $incomeProjected, incomeActual: $incomeActual)';
}


}

/// @nodoc
abstract mixin class _$BudgetMonthCopyWith<$Res> implements $BudgetMonthCopyWith<$Res> {
  factory _$BudgetMonthCopyWith(_BudgetMonth value, $Res Function(_BudgetMonth) _then) = __$BudgetMonthCopyWithImpl;
@override @useResult
$Res call({
 String yearMonth, Map<String, double> projected, Map<String, double> actual, double incomeProjected, double incomeActual
});




}
/// @nodoc
class __$BudgetMonthCopyWithImpl<$Res>
    implements _$BudgetMonthCopyWith<$Res> {
  __$BudgetMonthCopyWithImpl(this._self, this._then);

  final _BudgetMonth _self;
  final $Res Function(_BudgetMonth) _then;

/// Create a copy of BudgetMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yearMonth = null,Object? projected = null,Object? actual = null,Object? incomeProjected = null,Object? incomeActual = null,}) {
  return _then(_BudgetMonth(
yearMonth: null == yearMonth ? _self.yearMonth : yearMonth // ignore: cast_nullable_to_non_nullable
as String,projected: null == projected ? _self._projected : projected // ignore: cast_nullable_to_non_nullable
as Map<String, double>,actual: null == actual ? _self._actual : actual // ignore: cast_nullable_to_non_nullable
as Map<String, double>,incomeProjected: null == incomeProjected ? _self.incomeProjected : incomeProjected // ignore: cast_nullable_to_non_nullable
as double,incomeActual: null == incomeActual ? _self.incomeActual : incomeActual // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
