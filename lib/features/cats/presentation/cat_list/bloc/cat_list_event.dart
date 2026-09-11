part of 'cat_list_bloc.dart';

@freezed
abstract class CatListEvent with _$CatListEvent {
  const factory CatListEvent.initialize({String? query}) = _Initialize;
  const factory CatListEvent.search({required String query}) = _Search;
  const factory CatListEvent.loadMore() = _LoadMore;
}
