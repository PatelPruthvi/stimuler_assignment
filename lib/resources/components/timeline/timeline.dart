import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/day_model.dart';
import '../../../models/exersice_model.dart';
import '../../colors/colors.dart';
import '../../utils/utils.dart';

//timeline title
class TimelineTitle extends StatelessWidget {
  const TimelineTitle({
    super.key,
    required this.nodePositions,
    required this.i,
    required this.days,
  });

  final List<Offset> nodePositions;
  final int i;
  final List<DayModel> days;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: nodePositions[i].dx + 60, // Otherwise position it to the right
      top: nodePositions[i].dy + 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: days[i].isCompleted
                ? AppColors.kDarkGreen
                : i > 0
                    ? days[i - 1].isCompleted
                        ? AppColors.kBlue
                        : Colors.transparent
                    : AppColors.kBlue,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          days[i].title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// timeline node
class TimelineNode extends StatelessWidget {
  const TimelineNode({
    super.key,
    required this.nodePositions,
    required this.i,
    required this.days,
  });

  final List<Offset> nodePositions;
  final int i;
  final List<DayModel> days;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: nodePositions[i].dx, // Adjust for the node size
      top: nodePositions[i].dy, // Adjust for the node size
      child: GestureDetector(
        onTap: () {
          if (!days[i].isCompleted && (i == 0 || days[i - 1].isCompleted)) {
            List<Exersice> exersiceList = days[i].exersices;
            Utils.showBottomSheet(context: context, exersiceList: exersiceList);
          } else if (days[i].isCompleted) {
            Utils.showSnackBar(
                msg: "You have already completed this exersice...",
                context: context);
          }
        },
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: days[i].isCompleted
                  ? AppColors.kDarkGreen
                  : (i == 0 || days[i - 1].isCompleted)
                      ? AppColors.kBlue
                      : AppColors.kDarkGray,
            ),
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.kWhite, width: 3)),
                ))),
      ),
    );
  }
}

//curved timeline painter
class VerticalSerpentineLinePainter extends CustomPainter {
  final Path path;
  final int index;
  final List<Offset> nodePositions;
  VerticalSerpentineLinePainter(this.path, this.index, this.nodePositions);

  double _getPathDistanceAtOffset(PathMetric metric, Offset node) {
    // Get the path bounds
    final Rect bounds = path.getBounds();

    // Scale the node's vertical position (dy) relative to the path's height
    final double normalizedDy = (node.dy - bounds.top) / bounds.height;

    // Return the scaled distance along the path
    return metric.length * normalizedDy;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Define paint styles for different sections
    final paint1 = Paint()
      ..color = AppColors.kDarkGreen
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = AppColors.kDarkGray!
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    // Extract separate sections of the path
    Path section1 = Path();
    Path section2 = Path();

    // Using path metrics to divide the path
    final pathMetrics = path.computeMetrics();

    for (var metric in pathMetrics) {
      final length = metric.length;
      final firstSectionEnd =
          _getPathDistanceAtOffset(metric, nodePositions[index]);
      section1.addPath(
        metric.extractPath(0, firstSectionEnd),
        Offset.zero,
      );

      section2.addPath(
        metric.extractPath(firstSectionEnd, length),
        Offset.zero,
      );
    }

    // Draw the sections with different colors
    canvas.drawPath(section1, paint1);
    canvas.drawPath(section2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
