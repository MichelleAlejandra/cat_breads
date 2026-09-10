part of 'cat_detail_bloc.dart';

@freezed
class CatDetailState with _$CatDetailState {
  const factory CatDetailState.loading() = _Loading;
  const factory CatDetailState.loaded() = _Loaded;
  const factory CatDetailState.error() = _Error;
}
