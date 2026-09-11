import 'dart:async';

import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_list_event.dart';
part 'cat_list_state.dart';
part 'cat_list_bloc.freezed.dart';

class CatListBloc extends Bloc<CatListEvent, CatListState> {
  CatListBloc({required this.repository}) : super(_Loading()) {
    on<_Initialize>(_onInitialize);
    on<_LoadMore>(_onLoadMore);
    on<_Search>(_onSearch);
  }
  final CatRepository repository;

  final int _limit = 10;
  final int _initialPage = 0;

  Timer? _debounce;

  static const _searchDebounceDuration = Duration(milliseconds: 1500);

  Future<void> _onInitialize(
    _Initialize event,
    Emitter<CatListState> emit,
  ) async {
    emit(CatListState.loading());

    final int page = _initialPage;

    final catsResult = await repository.getCatBreeds(
      page: page,
      limit: _limit,
      query: event.query,
    );

    catsResult.when(
      left: (failure) => emit(CatListState.error()),
      right: (catList) => emit(
        CatListState.loaded(
          cats: catList,
          page: page,
          limit: _limit,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<CatListState> emit) async {
    await state.mapOrNull(
      loaded: (state) async {
        if (state.isLoadingMore || state.hasReachedMax) {
          return;
        }

        emit(state.copyWith(isLoadingMore: true));

        final int page = state.page + 1;

        final catsResult = await repository.getCatBreeds(
          page: page,
          limit: _limit,
        );

        final List<Cat>? newCats = catsResult.whenOrNull(
          right: (catList) => catList,
        );

        emit(
          state.copyWith(
            cats: [...state.cats, ...newCats ?? []],
            page: newCats == null ? state.page : page,
            isLoadingMore: false,
            hasReachedMax: newCats == null || newCats.length < _limit,
          ),
        );
      },
    );
  }

  Future<void> _onSearch(_Search event, Emitter<CatListState> emit) async {
    _debounce?.cancel();

    _debounce = Timer(_searchDebounceDuration, () {
      add(_Initialize(query: event.query));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
