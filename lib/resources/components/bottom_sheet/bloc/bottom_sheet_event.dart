part of 'bottom_sheet_bloc.dart';

@immutable
sealed class BottomSheetEvent {}

class BottomSheetTileClickedEvent extends BottomSheetEvent {
  final Exersice exersice;

  BottomSheetTileClickedEvent({required this.exersice});
}

class BottomSheetInitialEvent extends BottomSheetEvent {}
