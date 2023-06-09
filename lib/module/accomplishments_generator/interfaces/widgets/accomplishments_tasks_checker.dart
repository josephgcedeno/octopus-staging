import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';

enum CheckerType {
  selected,
  unselected,
}

class AccomplishmentsTaskChecker extends StatelessWidget {
  const AccomplishmentsTaskChecker({
    required this.title,
    required this.type,
    required this.onTap,
    this.hasProfile = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool hasProfile;
  final CheckerType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (hasProfile)
                  CircleAvatar(
                    minRadius: kIsWeb && width > smWebMinWidth
                        ? width * 0.009
                        : width * 0.04,
                    maxRadius: kIsWeb && width > smWebMinWidth
                        ? width * 0.009
                        : width * 0.04,
                    backgroundImage: const NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(title),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
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
          ),
        ],
      ),
    );
  }
}
