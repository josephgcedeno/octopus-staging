import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
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
        subtitle: 'Personal Information',
        title: 'Registration',
        buttonFunction: () {},
        body: Form(
          child: Column(
            children: <Widget>[
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
                                  return i == 0 ? 'First Name' : 'Last Name';
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
                textEditingController: emailTextController,
                hint: 'Email',
              ),
              FullWidthTextField(
                textEditingController: birthdateTextController,
                hint: 'Birthdate',
              ),
              FullWidthTextField(
                textEditingController: addressTextController,
                hint: 'Address',
              ),
              const Divider(),
              FullWidthTextField(
                textEditingController: positionTextController,
                hint: 'Position',
              ),
              FullWidthTextField(
                textEditingController: dateHiredTextController,
                hint: 'Date Hired',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
