import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_detail_event.dart';
part 'cat_detail_state.dart';
part 'cat_detail_bloc.freezed.dart';

class CatDetailBloc extends Bloc<CatDetailEvent, CatDetailState> {
  CatDetailBloc({required this.repository}) : super(_Loading()) {
    on<_Initialize>(_onInitialize);
  }

  final CatRepository repository;

  Future<void> _onInitialize(
    _Initialize event,
    Emitter<CatDetailState> emit,
  ) async {
    emit(CatDetailState.loading());

    final catResult = await repository.getCatById(id: event.id);

    catResult.when(
      left: (failure) => emit(CatDetailState.error()),
      right: (cat) => emit(CatDetailState.loaded(cat: cat)),
    );
  }
}
