part of 'cat_detail_bloc.dart';

@freezed
abstract class CatDetailEvent with _$CatDetailEvent {
  const factory CatDetailEvent.initialize({required String id}) = _Initialize;
}
