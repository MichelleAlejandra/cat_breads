part of 'cat_detail_bloc.dart';

@freezed
abstract class CatDetailState with _$CatDetailState {
  const factory CatDetailState.loading() = _Loading;
  const factory CatDetailState.loaded({required Cat cat}) = _Loaded;
  const factory CatDetailState.error() = _Error;
}
