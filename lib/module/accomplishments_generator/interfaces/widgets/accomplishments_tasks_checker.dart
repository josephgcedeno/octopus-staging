import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

enum CheckerType {
  selected,
  unselected,
}

class AccomplishmentsTaskChecker extends StatelessWidget {
  const AccomplishmentsTaskChecker({
    required this.title,
    required this.type,
    this.hasProfile = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool hasProfile;
  final CheckerType type;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (hasProfile)
                CircleAvatar(
                  minRadius: width * 0.04,
                  maxRadius: width * 0.04,
                  backgroundImage: const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(title),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              color: type == CheckerType.selected
                  ? kLightRed.withOpacity(0.08)
                  : kAqua.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type == CheckerType.selected ? Icons.close : Icons.check,
              color: type == CheckerType.selected ? kLightRed : kAqua,
            ),
          ),
        ],
      ),
    );
  }
}
