import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/members_profile_screen.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

class TeamMember extends StatefulWidget {
  const TeamMember({
    required this.user,
    required this.callback,
    required this.updateButtonStatus,
    Key? key,
  }) : super(key: key);
  final bool updateButtonStatus;
  final User user;
  final void Function(User user) callback;
  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
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
          BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
            builder: (BuildContext context, AdminRegistrationState state) {
              if (state is UpdateUserStatusLoading &&
                  state.id == widget.user.id) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  width: width * 0.1,
                  height: height * 0.09,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 93, 92, 92)
                          .withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: LoadingIndicator(),
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => widget.callback.call(widget.user),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  width: width * 0.1,
                  height: height * 0.09,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.updateButtonStatus
                          ? const Color(0xFFE25252).withOpacity(0.2)
                          : const Color(0xff39C0C7).withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: widget.updateButtonStatus
                        ? const Icon(
                            Icons.close_rounded,
                            color: Color(0xFFE25252),
                            size: 20,
                          )
                        : const Icon(
                            Icons.check,
                            color: Color(0xff39C0C7),
                            size: 20,
                          ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<dynamic>(
              builder: (_) => MembersProfileScreen(
                user: widget.user,
              ),
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
                      widget.user.profileImageSource,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(width * 0.01),
                child: Text(
                  widget.user.position,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
