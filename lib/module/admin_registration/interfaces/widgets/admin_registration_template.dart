import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TemplateVariation {
  teamMembers,
  personalInformaton,
  iDs,
}

class AdminRegistrationTemplate extends StatelessWidget {
  const AdminRegistrationTemplate({
    required this.body,
    required this.title,
    required this.subtitle,
    required this.buttonName,
    required this.buttonFunction,
    required this.templateVariation,
    Key? key,
  }) : super(key: key);
  final Widget body;
  final String title;
  final String subtitle;
  final String buttonName;
  final TemplateVariation templateVariation;
  final void Function() buttonFunction;

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
                        child: Center(
                          child: Text(
                            title,
                            style: kIsWeb
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (templateVariation != TemplateVariation.teamMembers)
                    Container(
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
                  Text(
                    subtitle,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
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
        if (templateVariation == TemplateVariation.iDs)
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              margin: EdgeInsets.only(
                bottom: height * 0.1,
              ),
              child: TextButton(
                onPressed: buttonFunction,
                child: Text(
                  'Skip',
                  style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.w500,),
                ),
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
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              onPressed: buttonFunction,
              child: Text(buttonName),
            ),
          ),
        )
      ],
    );
  }
}
