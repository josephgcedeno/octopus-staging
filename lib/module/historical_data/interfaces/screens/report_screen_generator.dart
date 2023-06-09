import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/screens/pdf_viewer_screen.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/upload_progress.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/export_pdf_button.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/report_screen_page_generator.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

enum ReportType { attendance, dsr, leaveReques }

class ReportScreenGenerator extends StatefulWidget {
  const ReportScreenGenerator({
    required this.reportDate,
    required this.reportType,
    this.leaveType,
    Key? key,
  }) : super(key: key);
  final String reportDate;
  final ReportType reportType;
  final String? leaveType;

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

  void showPdfGenerationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PdfGenerationDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<HistoricalCubit, HistoricalState>(
      listenWhen: (HistoricalState previous, HistoricalState current) =>
          current is ExportPDFLoading || current is ExportPDFSucess,
      listener: (BuildContext context, HistoricalState state) {
        if (state is ExportPDFLoading) {
          showPdfGenerationDialog(context);
        } else if (state is ExportPDFSucess) {
          Navigator.of(context).pop(); // pop the alert dialog

          Navigator.of(context).push(
            PageRouteBuilder<dynamic>(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
              ) =>
                  SidebarScreen(
                child: PDFViewerScreen(
                  pdf: state.document,
                  title: 'Historical Data',
                ),
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffECECEC),
        appBar: AppBar(
          title: kIsWeb && width > smWebMinWidth
              ? Text(
                  'Historical Data',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          centerTitle: kIsWeb && width > smWebMinWidth ? false : null,
          backgroundColor: kWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: kBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Container(
            width: kIsWeb && width > smWebMinWidth ? width * 0.50 : width,
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
              bottom: height * 0.02,
            ),
            color: Colors.white,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constrains) {
                return Column(
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
                              height: constrains.maxHeight * 0.055,
                              child: Image.asset(
                                nuxifyLogoPng,
                                height: 67.63,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '$reportTitle ${widget.leaveType != null ? '- ${widget.leaveType!.toTitleCase()}' : ''}',
                                    ),
                                  ),
                                  Text(
                                    widget.reportDate,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Expanded(
                      child: ReportScreenPageGenerator(),
                    ),
                    ExportPDFButton(
                      dateReport: widget.reportDate,
                      title:
                          '$reportTitle ${widget.leaveType != null ? '- ${widget.leaveType!.toTitleCase()}' : ''}',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
