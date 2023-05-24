import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/service/cubit/secure_storage_cubit_cubit.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/local_storage.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/team_members_list_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/member_information_component.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

/// This will identifies whether this screen is being launch by admin or user!.
///
/// [admin] identifies that this is launch via list of employee
///
/// [user] identifies that this is being viewed by user itself by tapping user icon.
enum UserView { admin, user }

class MembersProfileScreen extends StatefulWidget {
  const MembersProfileScreen({
    required this.userView,
    this.user,
    Key? key,
  }) : super(key: key);
  final UserView userView;
  final User? user;

  @override
  State<MembersProfileScreen> createState() => _MembersProfileScreenState();
}

class _MembersProfileScreenState extends State<MembersProfileScreen> {
  late final User user;
  Future<String> getFromSecureStorage(String key) async =>
      await context.read<SecureStorageCubit>().read(key: key) ?? '';

  Future<User> retrieveValuesFromSecureStorage() async {
    final String id = await getFromSecureStorage(lsId);
    final String firstName = await getFromSecureStorage(lsFirstName);
    final String lastName = await getFromSecureStorage(lsLastName);
    final String nuxifyId = await getFromSecureStorage(lsNuxifyId);
    final String birthDateEpoch = await getFromSecureStorage(lsBirthDateEpoch);
    final String address = await getFromSecureStorage(lsAddress);
    final String civilStatus = await getFromSecureStorage(lsCivilStatus);
    final String dateHiredEpoch = await getFromSecureStorage(lsDateHiredEpoch);
    final String profileImageSource =
        await getFromSecureStorage(lsProfileImageSource);
    final String isDeactive = await getFromSecureStorage(lsIsDeactive);
    final String position = await getFromSecureStorage(lsPosition);
    final String pagIbigNo = await getFromSecureStorage(lsPagIbigNo);
    final String sssNo = await getFromSecureStorage(lsSssNo);
    final String tinNo = await getFromSecureStorage(lsTinNo);
    final String philHealthNo = await getFromSecureStorage(lsPhilHealthNo);
    final String userId = await getFromSecureStorage(lsUserId);

    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      nuxifyId: nuxifyId,
      birthDateEpoch: int.parse(birthDateEpoch),
      address: address,
      civilStatus: civilStatus,
      dateHiredEpoch: int.parse(dateHiredEpoch),
      profileImageSource: profileImageSource,
      isDeactive: isDeactive == 'true',
      position: position,
      pagIbigNo: pagIbigNo,
      sssNo: sssNo,
      tinNo: tinNo,
      philHealtNo: philHealthNo,
      userId: userId,
    );
  }

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
  void initState() {
    super.initState();
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
        appBar: GlobalAppBar(
          leading: LeadingButton.back,
          isShowUserIcon: widget.userView == UserView.admin,
        ),
        body: FutureBuilder<User>(
          future: retrieveValuesFromSecureStorage(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.data != null && snapshot.hasData) {
              if (widget.user != null && widget.userView == UserView.admin) {
                user = widget.user!;
              } else {
                user = snapshot.data!;
              }
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: kIsWeb && width > smWebMinWidth
                            ? width * 0.40
                            : width * 0.80,
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                minRadius: kIsWeb && width > smWebMinWidth
                                    ? width * 0.04
                                    : width * 0.18,
                                maxRadius: kIsWeb && width > smWebMinWidth
                                    ? width * 0.04
                                    : width * 0.18,
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
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.08),
                                child: Column(
                                  children: <Widget>[
                                    InformationComponent(
                                      type: 'ID',
                                      value: user.nuxifyId,
                                    ),
                                    InformationComponent(
                                      type: 'Name',
                                      value:
                                          '${user.firstName} ${user.lastName}',
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
                                      value: DateFormat('MMdd/yyyy').format(
                                        dateTimeFromEpoch(
                                          epoch: user.dateHiredEpoch,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.userView == UserView.admin)
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: BlocBuilder<AdminRegistrationCubit,
                              AdminRegistrationState>(
                            builder: (
                              BuildContext context,
                              AdminRegistrationState state,
                            ) {
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
                                          ? const Color(0xFFE25252)
                                              .withOpacity(0.2)
                                          : const Color(0xff39C0C7)
                                              .withOpacity(0.2),
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
              );
            }
            return SizedBox.fromSize();
          },
        ),
      ),
    );
  }
}
