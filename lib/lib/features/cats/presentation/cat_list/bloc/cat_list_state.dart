part of 'cat_list_bloc.dart';

@freezed
class CatListState with _$CatListState {
  const factory CatListState.loading() = _Loading;
  const factory CatListState.loaded({
    required List<Cat> cats,
    required int page,
    required int limit,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
  }) = _Loaded;
  const factory CatListState.error() = _Error;
}
