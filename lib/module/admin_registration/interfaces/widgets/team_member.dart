import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/screens/members_profile_screen.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
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

    Widget isBtnClicked() => Container(
          padding: const EdgeInsets.all(2),
          width: width * 0.1,
          height: height * 0.09,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 93, 92, 92).withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Padding(
              padding: kIsWeb && width > smWebMinWidth
                  ? const EdgeInsets.symmetric(vertical: 15, horizontal: 5)
                  : const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
              child: const LoadingIndicator(),
            ),
          ),
        );

    return kIsWeb && width > smWebMinWidth
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<dynamic>(
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2,
                  ) =>
                      SidebarScreen(
                    child: MembersProfileScreen(
                      user: widget.user,
                      userView: UserView.admin,
                    ),
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
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
                        backgroundImage: NetworkImage(
                          widget.user.profileImageSource,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kIsWeb ? 18 : 12.11,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.user.firstName} ${widget.user.lastName}',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                widget.user.position,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 30,
                    height: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: widget.updateButtonStatus
                          ? const Color(0xFFE25252).withOpacity(0.2)
                          : const Color(0xff39C0C7).withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: BlocBuilder<AdminRegistrationCubit,
                        AdminRegistrationState>(
                      builder:
                          (BuildContext context, AdminRegistrationState state) {
                        if (state is UpdateUserStatusLoading &&
                            state.id == widget.user.id) {
                          return isBtnClicked();
                        }
                        return FittedBox(
                          child: IconButton(
                            color: const Color(0xff39C0C7),
                            onPressed: () => widget.callback.call(widget.user),
                            icon: widget.updateButtonStatus
                                ? const Icon(
                                    Icons.close_rounded,
                                    color: Color(0xFFE25252),
                                  )
                                : const Icon(
                                    Icons.check,
                                    color: Color(0xff39C0C7),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Slidable(
            endActionPane: ActionPane(
              extentRatio: width * 0.00043,
              motion: const ScrollMotion(),
              children: <Widget>[
                BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
                  builder:
                      (BuildContext context, AdminRegistrationState state) {
                    if (state is UpdateUserStatusLoading &&
                        state.id == widget.user.id) {
                      return isBtnClicked();
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
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
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2,
                    ) =>
                        SidebarScreen(
                      child: MembersProfileScreen(
                        user: widget.user,
                        userView: UserView.admin,
                      ),
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
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
                          backgroundImage: NetworkImage(
                            widget.user.profileImageSource,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kIsWeb ? 18 : 12.11,
                          ),
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
