import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/personal_information_form_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/team_member.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({Key? key}) : super(key: key);

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  List<User> activated = <User>[];
  List<User> deactivated = <User>[];

  void deactivateUser({required User targetUser, required int position}) {
    context
        .read<AdminRegistrationCubit>()
        .deactivateUser(id: targetUser.id, position: position);
  }

  void activateUser({required User targetUser, required int position}) {
    context
        .read<AdminRegistrationCubit>()
        .activateUser(id: targetUser.id, position: position);
  }

  @override
  void initState() {
    super.initState();
    context.read<AdminRegistrationCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<AdminRegistrationCubit, AdminRegistrationState>(
      listenWhen:
          (AdminRegistrationState previous, AdminRegistrationState current) =>
              current is FetchAllUsersLoading ||
              current is FetchAllUsersSuccess ||
              current is FetchAllUsersFailed ||
              current is UpdateUserStatusLoading ||
              current is UpdateUserStatusSuccess ||
              current is UpdateUserStatusFailed,
      listener: (BuildContext context, AdminRegistrationState state) {
        if (state is FetchAllUsersLoading) {
        } else if (state is FetchAllUsersSuccess) {
          setState(() {
            for (final User user in state.userList) {
              if (user.isDeactive) {
                deactivated.add(user);
              } else {
                activated.add(user);
              }
            }
          });
        } else if (state is FetchAllUsersFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
        if (state is UpdateUserStatusSuccess) {
          String status = 'activated.';

          if (state.userStatus == UserStatus.deactivate) {
            status = 'deactivated.';
            setState(() {
              activated.removeAt(state.position!);
              deactivated.add(state.response.data);
            });
          } else {
            setState(() {
              deactivated.removeAt(state.position!);
              activated.add(state.response.data);
            });
          }
          showSnackBar(
            message: 'User is $status',
          );
        } else if (state is UpdateUserStatusFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.back),
        body: AdminRegistrationTemplate(
          templateVariation: TemplateVariation.teamMembers,
          buttonName: 'Add Member',
          title: 'Team Members',
          buttonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (_) => const PersonalInformationFormScreen(),
              ),
            );
          },
          body: BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
            builder: (BuildContext context, AdminRegistrationState state) {
              if (state is FetchAllUsersLoading) {
                return Container(
                  margin: EdgeInsets.only(top: height * 0.005),
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < 7; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: lineLoader(
                            height: height * 0.057,
                            width: width,
                          ),
                        )
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11.0),
                        child: Text(
                          'Current Members',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (activated.isEmpty)
                        const Center(
                          child: Text('There is no Activated Members'),
                        ),
                      if (activated.isNotEmpty)
                        for (final User user in activated)
                          TeamMember(
                            updateButtonStatus: true,
                            callback: (User user) => deactivateUser(
                              targetUser: user,
                              position: activated.indexOf(user),
                            ),
                            user: user,
                          ),
                      if (deactivated.isNotEmpty)
                        Row(
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                'Deactivated',
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      for (final User user in deactivated)
                        TeamMember(
                          updateButtonStatus: false,
                          callback: (User user) => activateUser(
                            targetUser: user,
                            position: deactivated.indexOf(user),
                          ),
                          user: user,
                        )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
