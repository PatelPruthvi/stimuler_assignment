// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stimuler_assignment/views/home_view/ui/home_view.dart';
import 'package:stimuler_assignment/resources/colors/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stimuler Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'VarelaRound',
          bottomSheetTheme: BottomSheetThemeData(
              showDragHandle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              backgroundColor: AppColors.kBackgroundPurple,
              dragHandleSize: Size(50, 5)),
          textTheme: TextTheme(
              bodyMedium: TextStyle(
                  fontFamily: 'VarelaRound',
                  fontSize: 20,
                  color: AppColors.kWhite)),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'VarelaRound',
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
              backgroundColor: AppColors.kBlack,
              elevation: 0.0,
              centerTitle: false,
              foregroundColor: AppColors.kWhite),
          scaffoldBackgroundColor: AppColors.kBlack),
      home: HomeView(),
    );
  }
}
