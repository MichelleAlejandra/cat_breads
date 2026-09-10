part of 'cat_list_bloc.dart';

@freezed
class CatListState with _$CatListState {
  const factory CatListState.loading() = _Loading;
  const factory CatListState.loaded() = _Loaded;
  const factory CatListState.error() = _Error;
}
