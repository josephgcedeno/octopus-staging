import 'package:flutter/material.dart';

class TeamMember extends StatelessWidget {
  const TeamMember({
    required this.name,
    required this.position,
    required this.imageLink,
    Key? key,
  }) : super(key: key);
  final String name;
  final String position;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                minRadius: width * 0.04,
                maxRadius: width * 0.04,
                backgroundImage: NetworkImage(
                  imageLink,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(width * 0.01),
            child: Text(
              position,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
