import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/admin_registration/services/bloc/admin_registration_cubit.dart';

enum TemplateVariation {
  teamMembers,
  personalInformaton,
  iDs,
}

class AdminRegistrationTemplate extends StatelessWidget {
  const AdminRegistrationTemplate({
    required this.body,
    required this.title,
    required this.buttonName,
    required this.buttonFunction,
    required this.templateVariation,
    this.skipFunction,
    Key? key,
  }) : super(key: key);
  final Widget body;
  final String title;
  final String buttonName;
  final TemplateVariation templateVariation;
  final void Function() buttonFunction;
  final void Function()? skipFunction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            height: height * 0.87,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: height * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: height * 0.03, top: 20),
                          child: Align(
                            alignment: kIsWeb && width > smWebMinWidth
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (templateVariation != TemplateVariation.teamMembers)
                      Container(
                        width: kIsWeb && width > smWebMinWidth
                            ? width * 0.10
                            : width,
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        height: height * 0.003,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      templateVariation == TemplateVariation.iDs
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: body,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (templateVariation == TemplateVariation.iDs)
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
              builder: (BuildContext context, AdminRegistrationState state) {
                if (state is CreateUserLoading) {
                  return Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    margin: EdgeInsets.only(
                      bottom: height * 0.1,
                    ),
                    child: TextButton(
                      onPressed: null,
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    margin: EdgeInsets.only(
                      bottom: height * 0.1,
                    ),
                    child: TextButton(
                      onPressed: skipFunction,
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            width: kIsWeb && width > smWebMinWidth ? width * 0.25 : width,
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            margin: EdgeInsets.only(
              bottom: height * 0.02,
            ),
            child: BlocBuilder<AdminRegistrationCubit, AdminRegistrationState>(
              builder: (BuildContext context, AdminRegistrationState state) {
                if (state is CreateUserLoading) {
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
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    onPressed: buttonFunction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: Text(buttonName),
                    ),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
