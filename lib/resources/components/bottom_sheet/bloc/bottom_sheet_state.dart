// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bottom_sheet_bloc.dart';

@immutable
sealed class BottomSheetState {}

final class BottomSheetInitial extends BottomSheetState {}

class BottomSheetClickedTileState extends BottomSheetState {
  final bool isCompleted;
  BottomSheetClickedTileState({required this.isCompleted});
}
