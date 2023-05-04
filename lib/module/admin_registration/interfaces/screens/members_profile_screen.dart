import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/team_members_list_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/member_information_component.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

class MembersProfileScreen extends StatelessWidget {
  const MembersProfileScreen({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;
  void showAlertDialogOnDeactivateAccount(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xffA8A8A8).withOpacity(0.40),
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);

        return AlertDialog(
          alignment: const Alignment(0.0, -0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Deactivate Account',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 10),
          content: Text(
            'Are you sure you want to deactivate this account?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xff1B252F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff1B252F)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!user.isDeactive) {
                  context
                      .read<AdminRegistrationCubit>()
                      .deactivateUser(id: user.id);
                } else {
                  context
                      .read<AdminRegistrationCubit>()
                      .activateUser(id: user.id);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Confirm',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<AdminRegistrationCubit, AdminRegistrationState>(
      listenWhen:
          (AdminRegistrationState previous, AdminRegistrationState current) =>
              current is UpdateUserStatusFailed ||
              current is UpdateUserStatusLoading ||
              current is UpdateUserStatusSuccess,
      listener: (BuildContext context, AdminRegistrationState state) {
        if (state is UpdateUserStatusSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const TeamMembersScreen(),
            ),
            (Route<dynamic> route) => false,
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
        body: Stack(
          children: <Widget>[
            Container(
              height: height * 0.8,
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      minRadius: width * 0.18,
                      maxRadius: width * 0.18,
                      backgroundImage: NetworkImage(
                        user.profileImageSource,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(user.position),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: height,
                        child: Column(
                          children: <Widget>[
                            InformationComponent(
                              type: 'ID',
                              value: user.nuxifyId,
                            ),
                            InformationComponent(
                              type: 'Name',
                              value: '${user.firstName} ${user.lastName}',
                            ),
                            InformationComponent(
                              type: 'Birthdate',
                              value: DateFormat('MM/dd/yyyy').format(
                                dateTimeFromEpoch(
                                  epoch: user.birthDateEpoch,
                                ),
                              ),
                            ),
                            InformationComponent(
                              type: 'Address',
                              value: user.address,
                            ),
                            InformationComponent(
                              type: 'TIN No.',
                              value: user.tinNo,
                            ),
                            InformationComponent(
                              type: 'SSS No.',
                              value: user.sssNo,
                            ),
                            InformationComponent(
                              type: 'PAG-IBIG No.',
                              value: user.pagIbigNo,
                            ),
                            InformationComponent(
                              type: 'Philhealth No.',
                              value: user.philHealtNo,
                            ),
                            InformationComponent(
                              type: 'Date Hired',
                              value: DateFormat('MM/dd/yyyy').format(
                                dateTimeFromEpoch(
                                  epoch: user.dateHiredEpoch,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                margin: EdgeInsets.only(
                  bottom: height * 0.02,
                ),
                child:
                    BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
                  builder:
                      (BuildContext context, AdminRegistrationState state) {
                    if (state is UpdateUserStatusLoading) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey,
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        onPressed: null,
                        child: const LoadingIndicator(),
                      );
                    } else {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            !user.isDeactive
                                ? const Color(0xFFE25252).withOpacity(0.2)
                                : const Color(0xff39C0C7).withOpacity(0.2),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            !user.isDeactive
                                ? const Color(0xFFE25252)
                                : const Color(0xff39C0C7),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showAlertDialogOnDeactivateAccount(context);
                        },
                        child: Text(
                          !user.isDeactive
                              ? 'Deactivate Account'
                              : 'Activate Account',
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
