import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/team_members_list_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/full_width_reg_textfield.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

class IdsFormScreen extends StatefulWidget {
  const IdsFormScreen({
    required this.firstNameTextController,
    required this.lastNameTextController,
    required this.emailTextController,
    required this.birthdateTextController,
    required this.addressTextController,
    required this.positionTextController,
    required this.dateHiredTextController,
    required this.birthDate,
    required this.hireDate,
    Key? key,
  }) : super(key: key);
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController emailTextController;
  final TextEditingController birthdateTextController;
  final TextEditingController addressTextController;
  final TextEditingController positionTextController;
  final TextEditingController dateHiredTextController;
  final DateTime birthDate;
  final DateTime hireDate;
  @override
  State<IdsFormScreen> createState() => _IdsFormScreenState();
}

class _IdsFormScreenState extends State<IdsFormScreen> {
  final TextEditingController tinIDTextController = TextEditingController();
  final TextEditingController sssIDTextController = TextEditingController();
  final TextEditingController pagibigIDTextController = TextEditingController();
  final TextEditingController philhealthIDTextController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveForm() {
    context.read<AdminRegistrationCubit>().registerUser(
          firstName: widget.firstNameTextController.text,
          lastName: widget.lastNameTextController.text,
          email: widget.emailTextController.text,
          birthDate: widget.birthDate,
          address: widget.addressTextController.text,
          civilStatus: 'Single',
          dateHired: widget.hireDate,
          profileImageSource:
              'https://cdn-icons-png.flaticon.com/512/201/201634.png',
          position: widget.positionTextController.text,
          pagIbigNo: pagibigIDTextController.text,
          sssNo: sssIDTextController.text,
          tinNo: tinIDTextController.text,
          philHealtNo: philhealthIDTextController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminRegistrationCubit, AdminRegistrationState>(
      listenWhen:
          (AdminRegistrationState previous, AdminRegistrationState current) =>
              current is CreateUserLoading ||
              current is CreateUserSuccess ||
              current is CreateUserFailed,
      listener: (BuildContext context, AdminRegistrationState state) {
        if (state is CreateUserSuccess) {
          showSnackBar(message: 'User created successfully.');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const TeamMembersScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is CreateUserFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(
          leading: LeadingButton.back,
        ),
        body: AdminRegistrationTemplate(
          templateVariation: TemplateVariation.iDs,
          title: 'Registration',
          subtitle: "ID's",
          skipFunction: () {
            saveForm();
          },
          buttonFunction: () {
            if (_formKey.currentState!.validate()) {
              saveForm();
            }
          },
          buttonName: 'Save',
          body: Form(
            key: _formKey,
            child: Column(
              children: <FullWidthTextField>[
                FullWidthTextField(
                  tapFunction: () {},
                  textEditingController: tinIDTextController,
                  hint: 'TIN',
                  type: Type.normal,
                ),
                FullWidthTextField(
                  tapFunction: () {},
                  textEditingController: sssIDTextController,
                  hint: 'SSS No.',
                  type: Type.normal,
                ),
                FullWidthTextField(
                  tapFunction: () {},
                  textEditingController: pagibigIDTextController,
                  hint: 'Pag-Ibig No.',
                  type: Type.normal,
                ),
                FullWidthTextField(
                  tapFunction: () {},
                  textEditingController: philhealthIDTextController,
                  hint: 'PhilHealth No.',
                  type: Type.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
