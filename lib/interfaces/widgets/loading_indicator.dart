import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.03,
      width: height * 0.03,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}
