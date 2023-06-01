import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/ids_form_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/full_width_reg_textfield.dart';

class PersonalInformationFormScreen extends StatefulWidget {
  const PersonalInformationFormScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationFormScreen> createState() =>
      _PersonalInformationFormScreenState();
}

class _PersonalInformationFormScreenState
    extends State<PersonalInformationFormScreen> {
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController birthdateTextController = TextEditingController();
  final TextEditingController addressTextController = TextEditingController();
  final TextEditingController positionTextController = TextEditingController();
  final TextEditingController dateHiredTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DateTime birthDate = DateTime.now();
  late DateTime hireDate = DateTime.now();
  Future<void> openDatePicker({
    required BuildContext context,
    required int type,
  }) async {
    final DateTime? res = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (res == null || !mounted) return;

    final String dateFormat = DateFormat('MM/dd/yy').format(res);
    if (type == 0) {
      birthdateTextController.text = dateFormat;
      birthDate = res;
    } else {
      hireDate = res;
      dateHiredTextController.text = dateFormat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: AdminRegistrationTemplate(
        templateVariation: TemplateVariation.personalInformaton,
        buttonName: 'Next',
        title: 'Registration',
        buttonFunction: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).push(
              PageRouteBuilder<dynamic>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation1,
                  Animation<double> animation2,
                ) =>
                    SidebarScreen(
                  child: IdsFormScreen(
                    addressTextController: addressTextController,
                    birthdateTextController: birthdateTextController,
                    dateHiredTextController: dateHiredTextController,
                    emailTextController: emailTextController,
                    firstNameTextController: firstNameTextController,
                    lastNameTextController: lastNameTextController,
                    positionTextController: positionTextController,
                    birthDate: birthDate,
                    hireDate: hireDate,
                  ),
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        body: Align(
          child: SizedBox(
            width: kIsWeb && width > smWebMinWidth ? width * 0.50 : width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Personal Information',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      return Row(
                        children: <Widget>[
                          for (int i = 0; i < 2; i++)
                            Container(
                              margin: EdgeInsets.only(
                                right: constraints.maxWidth * 0.05,
                              ),
                              child: SizedBox(
                                width: constraints.maxWidth * 0.45,
                                child: TextFormField(
                                  controller: i == 0
                                      ? firstNameTextController
                                      : lastNameTextController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fields cannot be empty.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: () {
                                      return i == 0
                                          ? 'First Name'
                                          : 'Last Name';
                                    }(),
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  FullWidthTextField(
                    tapFunction: () {},
                    textEditingController: emailTextController,
                    hint: 'Email',
                    type: Type.normal,
                  ),
                  FullWidthTextField(
                    tapFunction: () {
                      openDatePicker(
                        context: context,
                        type: 0,
                      );
                    },
                    textEditingController: birthdateTextController,
                    hint: 'Birthdate',
                    type: Type.date,
                  ),
                  FullWidthTextField(
                    tapFunction: () {},
                    textEditingController: addressTextController,
                    hint: 'Address',
                    type: Type.normal,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const Divider(),
                  FullWidthTextField(
                    tapFunction: () {},
                    textEditingController: positionTextController,
                    hint: 'Position',
                    type: Type.normal,
                  ),
                  FullWidthTextField(
                    tapFunction: () {
                      openDatePicker(context: context, type: 1);
                    },
                    textEditingController: dateHiredTextController,
                    hint: 'Date Hired',
                    type: Type.date,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
