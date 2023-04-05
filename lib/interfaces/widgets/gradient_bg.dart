import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class GradientBG extends StatelessWidget {
  const GradientBG({required this.body, Key? key}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                gradient1,
                gradient2,
              ],
            ),
          ),
          child: body,
        ),
      ),
    );
  }
}
