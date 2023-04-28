import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/members_profile_screen.dart';

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
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: width * 0.00043,
        motion: const ScrollMotion(),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(2),
            width: width * 0.1,
            height: height * 0.09,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE25252).withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFFE25252),
                size: 20,
              ),
            ),
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<dynamic>(
              builder: (_) => const MembersProfileScreen(),
            ),
          );
        },
        child: Container(
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
        ),
      ),
    );
    ;
  }
}
