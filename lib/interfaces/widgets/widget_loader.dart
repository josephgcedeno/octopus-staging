import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

/// These are the static widgets that we're gonna use as skeleton loaders.
/// We use the Text Widget with dummy values to emulate the the exact dimensions of specific widgets
/// The text values won't show up because they are overlapped by the shimmer effect. It's just for height and width purposes.

const Color shimmerBase = Color(0xffFAF9FC);
const Color shimmerGlow = Color(0xFFE2E1E2);

const Duration fadeInDuration = Duration(milliseconds: 500);

Widget clockLoader(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: CircularPercentIndicator(
      radius: height * 0.15,
      lineWidth: 15.0,
      backgroundColor: Colors.transparent,
      progressColor: Colors.transparent,
      reverse: true,
      center: ClipRRect(
        borderRadius: BorderRadius.circular(width),
        child: Shimmer.fromColors(
          baseColor: shimmerBase,
          highlightColor: shimmerGlow,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: shimmerGlow,
            ),
            height: height,
          ),
        ),
      ),
    ),
  );
}

Widget leaveLoader(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: CircularPercentIndicator(
      radius: 60,
      lineWidth: 15.0,
      backgroundColor: Colors.transparent,
      progressColor: Colors.transparent,
      reverse: true,
      center: ClipRRect(
        borderRadius: BorderRadius.circular(width),
        child: Shimmer.fromColors(
          baseColor: shimmerBase,
          highlightColor: shimmerGlow,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: shimmerGlow,
            ),
            height: height,
          ),
        ),
      ),
    ),
  );
}

Widget lineLoader({
  required double height,
  required double width,
  bool withRadius = true,
  BorderRadiusGeometry? borderRadius,
}) {
  return Shimmer.fromColors(
    baseColor: shimmerBase,
    highlightColor: shimmerGlow,
    child: Container(
      decoration: BoxDecoration(
        borderRadius:
            withRadius ? borderRadius ?? BorderRadius.circular(8) : null,
        color: shimmerBase,
      ),
      width: width,
      height: height,
    ),
  );
}

List<Widget> itemLoader({
  required int outerItem,
  required int innerItem,
  double height = 20,
  double width = 100,
}) {
  return <Widget>[
    for (int i = 0; i < outerItem; i++)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
              left: 35,
            ),
            child: lineLoader(
              height: height,
              width: 100,
              withRadius: false,
            ),
          ),
          for (int j = 0; j < innerItem; j++)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                left: 30,
                right: 30,
              ),
              child: lineLoader(
                height: height + 10,
                width: double.infinity,
              ),
            )
        ],
      )
  ];
}

Widget sliderLoader(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return Column(
    children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.08,
        ),
        alignment: Alignment.center,
        child: lineLoader(
          height: height * 0.2,
          width: double.infinity,
        ),
      ),
      lineLoader(
        height: height * 0.010,
        width: width * 0.13,
      )
    ],
  );
}

Widget tasksLoader(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (int i = 0; i < 5; i++)
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(width * 0.03),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircularPercentIndicator(
                radius: width * 0.04,
                lineWidth: 1.5,
                backgroundColor: Colors.transparent,
                progressColor: Colors.transparent,
                reverse: true,
                center: ClipRRect(
                  borderRadius: BorderRadius.circular(width),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBase,
                    highlightColor: shimmerGlow,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: shimmerGlow,
                      ),
                      height: height,
                    ),
                  ),
                ),
              ),
            ),
            lineLoader(height: 12, width: width * 0.72),
          ],
        )
    ],
  );
}
