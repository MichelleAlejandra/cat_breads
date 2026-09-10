import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_list_event.dart';
part 'cat_list_state.dart';
part 'cat_list_bloc.freezed.dart';

class CatListBloc extends Bloc<CatListEvent, CatListState> {
  CatListBloc() : super(_Loading()) {
    on<CatListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
