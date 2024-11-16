import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/day_model.dart';
import '../../../resources/components/timeline/timeline.dart';
import '../bloc/home_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hey Mahesh"),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: homeBloc,
          builder: (context, state) {
            return Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CurvedTimeline(
                      nodeCount: state.days.length,
                      days: state.days,
                      lastIndex: state.lastCompletedLesson,
                    )));
          },
        ));
  }
}

class CurvedTimeline extends StatelessWidget {
  final List<DayModel> days;
  final int nodeCount;
  final double width;
  final double verticalSpacing;
  final int lastIndex;
  const CurvedTimeline(
      {super.key,
      required this.nodeCount,
      this.width = 300,
      this.verticalSpacing = 150,
      required this.days,
      required this.lastIndex});

  List<Offset> _generateNodePositions({
    required int nodeCount,
    required double width,
    required double verticalSpacing,
    required Path path,
  }) {
    if (nodeCount < 2) {
      debugPrint("Node count must be at least 2.");
    }

    // Reset and rebuild the serpentine path for the new height
    path.reset();
    double amplitude = -width * 0.8; // Horizontal swing of the serpentine
    double startX = width * 0.6;
    double startY = 0;

    path.moveTo(startX, startY);

    // Create serpentine path for the entire height
    for (int i = 0; i < nodeCount - 1; i++) {
      double controlX = startX + amplitude * (i % 2 == 0 ? 1 : -1);
      double controlY = startY + verticalSpacing / 2;
      double endX = startX;
      double endY = startY + verticalSpacing;

      path.quadraticBezierTo(controlX, controlY, endX, endY);
      startY = endY;
    }

    double totalPathLength =
        path.computeMetrics().fold(0, (sum, metric) => sum + metric.length);
    final random = Random();
    // Generate node positions
    final List<Offset> nodePositions = [];
    double segmentLength = totalPathLength / (nodeCount - 1);
    for (int i = 0; i < nodeCount; i++) {
      PathMetrics metrics = path.computeMetrics();
      double targetLength = 0;
      if (i == 0 || i == nodeCount - 1) {
        targetLength = i * segmentLength;
      } else {
        targetLength = (i * segmentLength) +
            (random.nextDouble() * segmentLength * 0.3); //30% fitter
      }
      for (PathMetric metric in metrics) {
        if (targetLength <= metric.length) {
          Tangent? tangent = metric.getTangentForOffset(targetLength);
          if (tangent != null) {
            nodePositions.add(tangent.position);
          }
          break;
        } else {
          targetLength -= metric.length;
        }
      }
    }

    return nodePositions;
  }

  @override
  Widget build(BuildContext context) {
    // Total vertical height of the path
    final path = Path();
    List<Offset> nodePositions = _generateNodePositions(
      nodeCount: nodeCount,
      width: width,
      verticalSpacing: verticalSpacing,
      path: path,
    );

    return Stack(
      clipBehavior: Clip.none, // Ensures nodes are not clipped
      children: [
        // The serpentine line
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                (nodeCount - 1) * verticalSpacing),
            painter:
                VerticalSerpentineLinePainter(path, lastIndex, nodePositions),
          ),
        ),
        // Nodes placed along the line
        for (int i = 0; i < nodePositions.length; i++)
          TimelineNode(nodePositions: nodePositions, i: i, days: days),
        for (int i = 0; i < nodePositions.length; i++)
          TimelineTitle(nodePositions: nodePositions, i: i, days: days),
      ],
    );
  }
}
