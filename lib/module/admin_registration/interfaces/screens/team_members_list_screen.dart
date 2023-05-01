import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<AdminRegistrationCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);

    return BlocListener<AdminRegistrationCubit, AdminRegistrationState>(
      listenWhen:
          (AdminRegistrationState previous, AdminRegistrationState current) =>
              current is FetchAllUsersLoading ||
              current is FetchAllUsersSuccess ||
              current is FetchAllUsersFailed,
      listener: (BuildContext context, AdminRegistrationState state) {
        if (state is FetchAllUsersLoading) {}
        if (state is FetchAllUsersSuccess) {
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
        if (state is FetchAllUsersFailed) {}
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.back),
        body: AdminRegistrationTemplate(
          templateVariation: TemplateVariation.teamMembers,
          buttonName: 'Add Member',
          subtitle: 'Current Members',
          title: 'Team Members',
          buttonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (_) => const PersonalInformationFormScreen(),
              ),
            );
          },
          body: SizedBox(
            child: Column(
              children: <Widget>[
                for (final User user in activated)
                  TeamMember(
                    user: user,
                    isDeactivated: user.isDeactive,
                    name: '${user.firstName} ${user.lastName}',
                    imageLink:
                        'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                    position: user.position,
                  ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                    user: user,
                    isDeactivated: user.isDeactive,
                    name: '${user.firstName} ${user.lastName}',
                    imageLink:
                        'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                    position: user.position,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
