import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stimuler_assignment/models/exersice_model.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  BottomSheetBloc() : super(BottomSheetInitial()) {
    on<BottomSheetTileClickedEvent>(bottomSheetTileClickedEvent);
    on<BottomSheetInitialEvent>(bottomSheetInitialEvent);
  }

  FutureOr<void> bottomSheetTileClickedEvent(
      BottomSheetTileClickedEvent event, Emitter<BottomSheetState> emit) {
    emit(BottomSheetClickedTileState(isCompleted: event.exersice.isCompleted));
  }

  FutureOr<void> bottomSheetInitialEvent(
      BottomSheetInitialEvent event, Emitter<BottomSheetState> emit) {
    emit(BottomSheetInitial());
  }
}
