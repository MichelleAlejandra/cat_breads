part of 'cat_list_bloc.dart';

@freezed
abstract class CatListState with _$CatListState {
  const factory CatListState.loading() = _Loading;
  const factory CatListState.loaded({
    required List<Cat> cats,
    required int page,
    required int limit,
    String? query,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isSearching,
  }) = _Loaded;
  const factory CatListState.error() = _Error;
}
