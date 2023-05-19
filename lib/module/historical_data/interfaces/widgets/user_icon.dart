import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class UserIcon extends StatelessWidget {
  const UserIcon({
    required this.imageUrl,
    required this.userName,
    Key? key,
  }) : super(key: key);
  final String imageUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.network(
              imageUrl,
              width: 25,
              height: 25,
              fit: BoxFit.scaleDown,
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                userName,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: kLightBlack.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
