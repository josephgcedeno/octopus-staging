import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/daily_accomplishment_pdf_screen.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/daily_accomplishment_tabs.dart';

class DailyAccomplishmentReportScreen extends StatelessWidget {
  const DailyAccomplishmentReportScreen({required this.reportTasks, Key? key})
      : super(key: key);

  final Map<String, List<Map<String, String>>> reportTasks;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: kBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            bottom: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.30,
                        height: height * 0.055,
                        child: Image.asset(nuxifyLogoPng),
                      ),
                      const Text(
                        'DAILY ACCOMPLISHMENT REPORT',
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.06,
                ),
                child: RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Hello ',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontSize: height * 0.026),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          height: height * 0.03,
                          width: width * 0.3,
                          margin: EdgeInsets.only(bottom: height * 0.01),
                          child: TextField(
                            style: TextStyle(
                              color: theme.primaryColor,
                            ),
                            decoration: InputDecoration(
                              focusColor: theme.primaryColor,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: height * 0.009,
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: theme.primaryColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: theme.primaryColor),
                              ),
                              hintText: 'Name',
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            '. For today’s update with worth 8 hours of work.',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontSize: height * 0.026),
                      ),
                    ],
                  ),
                ),
              ),
              DailyAccomplishmentTabs(reportTasks: reportTasks),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: width * 0.06),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'You can see detailed cards update in our',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontSize: height * 0.017),
                          ),
                          TextSpan(
                            text: ' Asana ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: kLightRed,
                              fontSize: height * 0.017,
                            ),
                          ),
                          TextSpan(
                            text: 'board.',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontSize: height * 0.017),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text('Regards,'),
                  Text(
                    'Karl from Nuxify',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<dynamic>(
                          builder: (_) => const DailyAccomplishmentPDFScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.02,
                      ),
                      margin: EdgeInsets.only(top: width * 0.06),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Generate Accomplishment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.primaryColor,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
