import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_projects_slider.dart';

class AccomplishmentsGeneratorScreen extends StatelessWidget {
  const AccomplishmentsGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Accomplishment Generator',
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium,
                      ),
                    ),
                    const AccomplishmentsProjectSlider(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.02,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.04,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Proceed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
