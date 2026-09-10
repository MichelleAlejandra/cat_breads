import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_detail_event.dart';
part 'cat_detail_state.dart';
part 'cat_detail_bloc.freezed.dart';

class CatDetailBloc extends Bloc<CatDetailEvent, CatDetailState> {
  CatDetailBloc() : super(_Loading()) {
    on<CatDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
