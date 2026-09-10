part of 'cat_list_bloc.dart';

@freezed
class CatListEvent with _$CatListEvent {
  const factory CatListEvent.initialize() = _Initialize;
  const factory CatListEvent.search({required String query}) = _Search;
}
