import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

/// These are the static widgets that we're gonna use as skeleton loaders.
/// We use the Text Widget with dummy values to emulate the the exact dimensions of specific widgets
/// The text values won't show up because they are overlapped by the shimmer effect. It's just for height and width purposes.

const Color shimmerBase = Colors.white;
const Color shimmerGlow = Colors.black12;

const Duration fadeInDuration = Duration(milliseconds: 500);

Widget clockLoader(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: theme.primaryColor.withAlpha(30),
          blurRadius: 30,
        ),
      ],
    ),
    child: CircularPercentIndicator(
      radius: height * 0.15,
      lineWidth: 15.0,
      backgroundColor: theme.primaryColor.withAlpha(15),
      progressColor: kBlue.withAlpha(30),
      reverse: true,
      center: ClipRRect(
        borderRadius: BorderRadius.circular(width),
        child: Shimmer.fromColors(
          baseColor: shimmerBase,
          highlightColor: shimmerGlow,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black38,
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
}) {
  return Shimmer.fromColors(
    baseColor: shimmerBase,
    highlightColor: shimmerGlow,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: withRadius ? BorderRadius.circular(8) : null,
        color: Colors.white12,
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
