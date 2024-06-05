// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoodsModel _$GoodsModelFromJson(Map<String, dynamic> json) {
  return _GoodsModel.fromJson(json);
}

/// @nodoc
mixin _$GoodsModel {
  Map<String, dynamic> get goods => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsModelCopyWith<GoodsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsModelCopyWith<$Res> {
  factory $GoodsModelCopyWith(
          GoodsModel value, $Res Function(GoodsModel) then) =
      _$GoodsModelCopyWithImpl<$Res, GoodsModel>;
  @useResult
  $Res call({Map<String, dynamic> goods});
}

/// @nodoc
class _$GoodsModelCopyWithImpl<$Res, $Val extends GoodsModel>
    implements $GoodsModelCopyWith<$Res> {
  _$GoodsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goods = null,
  }) {
    return _then(_value.copyWith(
      goods: null == goods
          ? _value.goods
          : goods // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoodsModelImplCopyWith<$Res>
    implements $GoodsModelCopyWith<$Res> {
  factory _$$GoodsModelImplCopyWith(
          _$GoodsModelImpl value, $Res Function(_$GoodsModelImpl) then) =
      __$$GoodsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic> goods});
}

/// @nodoc
class __$$GoodsModelImplCopyWithImpl<$Res>
    extends _$GoodsModelCopyWithImpl<$Res, _$GoodsModelImpl>
    implements _$$GoodsModelImplCopyWith<$Res> {
  __$$GoodsModelImplCopyWithImpl(
      _$GoodsModelImpl _value, $Res Function(_$GoodsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goods = null,
  }) {
    return _then(_$GoodsModelImpl(
      goods: null == goods
          ? _value._goods
          : goods // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodsModelImpl extends _GoodsModel {
  const _$GoodsModelImpl({required final Map<String, dynamic> goods})
      : _goods = goods,
        super._();

  factory _$GoodsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodsModelImplFromJson(json);

  final Map<String, dynamic> _goods;
  @override
  Map<String, dynamic> get goods {
    if (_goods is EqualUnmodifiableMapView) return _goods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_goods);
  }

  @override
  String toString() {
    return 'GoodsModel(goods: $goods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsModelImpl &&
            const DeepCollectionEquality().equals(other._goods, _goods));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_goods));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsModelImplCopyWith<_$GoodsModelImpl> get copyWith =>
      __$$GoodsModelImplCopyWithImpl<_$GoodsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodsModelImplToJson(
      this,
    );
  }
}

abstract class _GoodsModel extends GoodsModel {
  const factory _GoodsModel({required final Map<String, dynamic> goods}) =
      _$GoodsModelImpl;
  const _GoodsModel._() : super._();

  factory _GoodsModel.fromJson(Map<String, dynamic> json) =
      _$GoodsModelImpl.fromJson;

  @override
  Map<String, dynamic> get goods;
  @override
  @JsonKey(ignore: true)
  _$$GoodsModelImplCopyWith<_$GoodsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
