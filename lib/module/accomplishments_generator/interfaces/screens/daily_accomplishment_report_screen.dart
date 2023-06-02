// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/screens/pdf_viewer_screen.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/upload_progress.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/daily_accomplishment_tabs.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/daily_accomplishment_text_field.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';

class DailyAccomplishmentReportScreen extends StatefulWidget {
  const DailyAccomplishmentReportScreen({Key? key}) : super(key: key);

  @override
  State<DailyAccomplishmentReportScreen> createState() =>
      _DailyAccomplishmentReportScreenState();
}

class _DailyAccomplishmentReportScreenState
    extends State<DailyAccomplishmentReportScreen> {
  late Map<String, List<DSRWorks>>? selectedTasks =
      context.read<AccomplishmentsCubit>().state.selectedTasks;

  String clientName = '';

  String _changeTabLabel(String tabName) {
    if (tabName == 'work_in_progress') {
      return 'DOING';
    } else if (tabName == 'blockers') {
      return 'BLOCKED';
    }
    return tabName.toUpperCase();
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

    return BlocListener<AccomplishmentsCubit, AccomplishmentsState>(
      listenWhen:
          (AccomplishmentsState previous, AccomplishmentsState current) =>
              current is GeneratePDFLoading ||
              current is GeneratePDFSuccess ||
              current is GeneratePDFFailed,
      listener: (BuildContext context, AccomplishmentsState state) {
        if (state is GeneratePDFLoading) {
          showPdfGenerationDialog(context);
        } else if (state is GeneratePDFSuccess) {
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
                  title: 'Accomplishment Generator',
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
          backgroundColor: kWhite,
          elevation: 0,
          title: kIsWeb && width > smWebMinWidth
              ? Text(
                  'Accomplishment Generator',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          centerTitle: kIsWeb && width > smWebMinWidth ? false : null,
          leading: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.chevron_left, color: kBlack),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            width: kIsWeb && width > smWebMinWidth ? width * 0.50 : width,
            height: height,
            color: Colors.white,
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
              bottom: height * 0.02,
              top: height * 0.02,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constrain) {
                return SizedBox(
                  width: constrain.maxWidth,
                  height: constrain.maxHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: constrain.maxHeight * 0.055,
                                  child: Image.asset(
                                    nuxifyLogoPng,
                                    height: 67.63,
                                  ),
                                ),
                                const Text(
                                  'DAILY ACCOMPLISHMENT REPORT',
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: constrain.maxWidth * 0.06,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: 'Hello ',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontSize: height * 0.026,
                                        color: kBlack,
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.top,
                                      child: DailyAccomplishmentTextField(
                                        name: (String name) {
                                          setState(() {
                                            clientName = name;
                                          });
                                        },
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '! For today’s update with worth 8 hours of work.',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontSize: height * 0.026,
                                        color: kBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const DailyAccomplishmentTabs(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: width * 0.06),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                              'You can see detailed cards update in our',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontSize: height * 0.017,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Asana ',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: kLightRed,
                                            fontSize: height * 0.017,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'board.',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontSize: height * 0.017,
                                          ),
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
                            if (kIsWeb && width > smWebMinWidth)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(
                                  height: 4,
                                  color: kDarkGrey,
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                if (selectedTasks == null) return;

                                final Map<String, List<String>> selectedCasted =
                                    <String, List<String>>{};

                                // Using forEach method
                                selectedTasks!.forEach(
                                    (String key, List<DSRWorks> value) {
                                  selectedCasted[
                                          _changeTabLabel(key).toLowerCase()] =
                                      value
                                          .map((DSRWorks obj) => obj.text)
                                          .toList();
                                });

                                context
                                    .read<AccomplishmentsCubit>()
                                    .generatePDFFile(
                                      name: clientName,
                                      selectedTasks: selectedCasted,
                                    );
                              },
                              child: Align(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: height * 0.02,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    vertical: height * 0.02,
                                    horizontal: kIsWeb && width > smWebMinWidth
                                        ? width * 0.04
                                        : 0.0,
                                  ),
                                  width: kIsWeb && width > smWebMinWidth
                                      ? constrain.maxWidth * 0.90
                                      : double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
