import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class DailyAccomplishmentPDFScreen extends StatelessWidget {
  const DailyAccomplishmentPDFScreen({
    required this.reportTasks,
    required this.clientName,
    Key? key,
  }) : super(key: key);

  final Map<String, List<Map<String, String>>> reportTasks;
  final String clientName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kLightGrey.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: kBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: const Icon(
              Icons.share_outlined,
              color: kLightBlack,
              size: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: const Icon(
              Icons.file_download_outlined,
              color: kLightBlack,
              size: 20,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: width * 0.06,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'Hello ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: height * 0.026,
                                  color: kBlack,
                                ),
                              ),
                              TextSpan(
                                text: clientName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: height * 0.026,
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '! For today’s update with worth 8 hours of work.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: height * 0.026,
                                  color: kBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: reportTasks.entries.map((
                          MapEntry<String, List<Map<String, String>>> entry,
                        ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: width,
                                padding: EdgeInsets.only(bottom: width * 0.010),
                                margin: EdgeInsets.symmetric(
                                  vertical: width * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: kDarkGrey.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: entry.value
                                    .map((Map<String, String> value) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(width * 0.02),
                                        child: const Icon(
                                          Icons.check,
                                          color: kLightBlack,
                                          size: 15,
                                        ),
                                      ),
                                      Text(value['text']!),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
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
                                text:
                                    'You can see detailed cards update in our',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
