import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/full_width_reg_textfield.dart';

class IdsFormScreen extends StatefulWidget {
  const IdsFormScreen({Key? key}) : super(key: key);

  @override
  State<IdsFormScreen> createState() => _IdsFormScreenState();
}

class _IdsFormScreenState extends State<IdsFormScreen> {
  final TextEditingController tinIDTextController = TextEditingController();
  final TextEditingController sssIDTextController = TextEditingController();
  final TextEditingController pagibigIDTextController = TextEditingController();
  final TextEditingController philhealthIDTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(
        leading: LeadingButton.back,
      ),
      body: AdminRegistrationTemplate(
        templateVariation: TemplateVariation.iDs,
        title: 'Registration',
        subtitle: "ID's",
        buttonFunction: () {},
        buttonName: 'Save',
        body: Form(
          child: Column(
            children: <FullWidthTextField>[
              FullWidthTextField(
                textEditingController: tinIDTextController,
                hint: 'TIN',
              ),
              FullWidthTextField(
                textEditingController: sssIDTextController,
                hint: 'SSS No.',
              ),
              FullWidthTextField(
                textEditingController: pagibigIDTextController,
                hint: 'Pag-Ibig No.',
              ),
              FullWidthTextField(
                textEditingController: philhealthIDTextController,
                hint: 'PhilHealth No.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
