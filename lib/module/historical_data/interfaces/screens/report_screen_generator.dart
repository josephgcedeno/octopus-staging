import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/report_screen_page_generator.dart';

enum ReportType { attendance, dsr, leaveReques }

class ReportScreenGenerator extends StatefulWidget {
  const ReportScreenGenerator({
    required this.reportDate,
    required this.reportType,
    Key? key,
  }) : super(key: key);
  final String reportDate;
  final ReportType reportType;

  @override
  State<ReportScreenGenerator> createState() => _ReportScreenGeneratorState();
}

class _ReportScreenGeneratorState extends State<ReportScreenGenerator> {
  String get reportTitle {
    switch (widget.reportType) {
      case ReportType.attendance:
        return 'DAILY TIME RECORD';
      case ReportType.dsr:
        return 'DAILY STANDUP REPORT';
      case ReportType.leaveReques:
        return 'LEAVE REQUESTS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = kIsWeb ? 600 : MediaQuery.of(context).size.width;

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
      body: SizedBox(
        width: width,
        height: height * 0.87,
        child: Padding(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            reportTitle,
                          ),
                          Text(
                            widget.reportDate,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Expanded(
                child: ReportScreenPageGenerator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
