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
}) {
  return Shimmer.fromColors(
    baseColor: shimmerBase,
    highlightColor: shimmerGlow,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black38,
      ),
      width: width,
      height: height,
    ),
  );
}
