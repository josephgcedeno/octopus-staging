// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/screens/pdf_viewer_screen.dart';
import 'package:octopus/interfaces/widgets/upload_progress.dart';
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
            MaterialPageRoute<dynamic>(
              builder: (_) => PDFViewerScreen(
                pdf: state.document,
              ),
            ),
          );
        }
      },
      child: Scaffold(
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
                          style: theme.textTheme.bodySmall?.copyWith(
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
                          style: theme.textTheme.bodySmall?.copyWith(
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
                    Container(
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
                      child: GestureDetector(
                        onTap: () async {
                          if (selectedTasks == null) return;

                          final Map<String, List<String>> selectedCasted =
                              <String, List<String>>{};

                          // Using forEach method
                          selectedTasks!
                              .forEach((String key, List<DSRWorks> value) {
                            selectedCasted[_changeTabLabel(key).toLowerCase()] =
                                value.map((DSRWorks obj) => obj.text).toList();
                          });

                          context.read<AccomplishmentsCubit>().generatePDFFile(
                                name: clientName,
                                selectedTasks: selectedCasted,
                              );
                        },
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
      ),
    );
  }
}
