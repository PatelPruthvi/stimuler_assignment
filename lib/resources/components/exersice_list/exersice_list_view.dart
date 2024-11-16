import 'package:flutter/material.dart';
import 'package:stimuler_assignment/resources/components/bottom_sheet/bloc/bottom_sheet_bloc.dart';

import '../../../models/exersice_model.dart';
import '../../colors/colors.dart';
import '../bottom_sheet/ui/custom_bottom_sheet.dart';

class ExersiceListView extends StatefulWidget {
  const ExersiceListView(
      {super.key, required this.exersiceList, required this.bottomSheetBloc});

  final List<Exersice> exersiceList;
  final BottomSheetBloc bottomSheetBloc;

  @override
  State<ExersiceListView> createState() => _ExersiceListViewState();
}

class _ExersiceListViewState extends State<ExersiceListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addRepaintBoundaries: true,
      shrinkWrap: true,
      itemCount: widget.exersiceList.length,
      itemBuilder: (context, index) {
        bool isEnabled = index == 0 ||
                (index > 0 &&
                    widget.exersiceList[index - 1].isCompleted == true)
            ? true
            : false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: isEnabled
                        ? widget.exersiceList[index].isCompleted
                            ? AppColors.kLightGreen
                            : AppColors.kDarkPurple
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              enabled: isEnabled,
              onTap: () {
                if (selectedIndex == index) {
                  selectedIndex = -1;
                  widget.bottomSheetBloc.add(BottomSheetInitialEvent());
                } else {
                  selectedIndex = index;
                  widget.bottomSheetBloc.add(BottomSheetTileClickedEvent(
                      exersice: widget.exersiceList[index]));
                }
                setState(() {});
              },
              selectedTileColor: widget.exersiceList[index].isCompleted
                  ? AppColors.kLightGreen
                  : AppColors.kLightPurple,
              selected: selectedIndex == index,
              textColor: AppColors.kLightGreen,
              selectedColor: AppColors.kWhite,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              leading: CircleAvatar(
                backgroundColor: AppColors.kDarkGray,
                radius: MediaQuery.of(context).size.height * 0.04,
                foregroundImage:
                    NetworkImage(widget.exersiceList[index].imgLink),
              ),
              title: Text(
                widget.exersiceList[index].title,
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
              trailing: widget.exersiceList[index].results != null
                  ? Text(
                      "${widget.exersiceList[index].results!.correctAnswers} / ${widget.exersiceList[index].results!.totalQuestions}",
                      style: const TextStyle(
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
