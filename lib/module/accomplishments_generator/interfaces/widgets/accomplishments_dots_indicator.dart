import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    required this.currentIndex,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        pageCount,
        (int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
