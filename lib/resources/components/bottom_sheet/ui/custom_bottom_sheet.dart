import 'package:flutter/material.dart';
import 'package:stimuler_assignment/resources/colors/colors.dart';
import 'package:stimuler_assignment/resources/components/bottom_sheet/bloc/bottom_sheet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stimuler_assignment/resources/utils/utils.dart';
import '../../../../models/exersice_model.dart';
import '../../exersice_list/exersice_list_view.dart';

int selectedIndex = -1;

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
    required this.exersiceList,
  });

  final List<Exersice> exersiceList;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final BottomSheetBloc bottomSheetBloc = BottomSheetBloc();
  @override
  void initState() {
    selectedIndex = -1; //reset the selected index
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.44,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose Exercise"),
            Expanded(
              child: ExersiceListView(
                  exersiceList: widget.exersiceList,
                  bottomSheetBloc: bottomSheetBloc),
            ),
            BlocBuilder<BottomSheetBloc, BottomSheetState>(
              bloc: bottomSheetBloc,
              builder: (context, state) {
                switch (state.runtimeType) {
                  case const (BottomSheetClickedTileState):
                    final successState = state as BottomSheetClickedTileState;
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            AppColors.kWhite),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            AppColors.kDarkPurple)),
                                onPressed: () {
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 8),
                                  child: Text(successState.isCompleted
                                      ? "Reattempt Exersice"
                                      : "Start Practise"),
                                )),
                          ),
                        ),
                      ],
                    );
                  default:
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    enableFeedback: false,
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            AppColors.kWhite),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.kDarkPurple
                                            .withOpacity(0.4))),
                                onPressed: () {
                                  Utils.showToast(
                                      msg:
                                          'Please select an exersice to start practising.');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 8),
                                  child: Text("Start Practise"),
                                )),
                          ),
                        ),
                      ],
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
