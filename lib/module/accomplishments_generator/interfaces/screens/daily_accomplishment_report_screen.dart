import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/daily_accomplishment_pdf_screen.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/daily_accomplishment_tabs.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/daily_accomplishment_text_field.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String clientName = '';

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

  String _changeTabLabel(String tabName) {
    if (tabName == 'work_in_progress') {
      return 'DOING';
    } else if (tabName == 'blockers') {
      return 'BLOCKED';
    }
    return tabName.toUpperCase();
  }

  Future<File> generateDocument() async {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    selectedTasks = context.read<AccomplishmentsCubit>().state.selectedTasks;

    final pw.Document pdf = pw.Document();

    final ByteData imageData = await rootBundle.load(nuxifyLogoPng);
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final pw.MemoryImage image = pw.MemoryImage(imageBytes);

    final ByteData gilroyRegular =
        await rootBundle.load('assets/fonts/Gilroy/Gilroy-Regular.ttf');
    final ByteData gilroyBold =
        await rootBundle.load('assets/fonts/Gilroy/Gilroy-Bold.ttf');
    final ByteData fontFamilyFallback =
        await rootBundle.load('assets/fonts/Gilroy/Gilroy-Regular.ttf');

    final pw.TextStyle textStyleMain = pw.TextStyle(
      font: pw.Font.ttf(gilroyRegular),
      fontSize: height * 0.026,
      lineSpacing: 1.8,
      fontFallback: <pw.Font>[pw.Font.ttf(fontFamilyFallback)],
      color: PdfColors.black,
    );

    final pw.TextStyle textStyleBold = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      font: pw.Font.ttf(gilroyBold),
      fontSize: height * 0.026,
      lineSpacing: 1.8,
      fontFallback: <pw.Font>[pw.Font.ttf(fontFamilyFallback)],
    );

    final pw.SvgImage checkIcon = pw.SvgImage(
      svg:
          '<svg viewBox="0 0 20 20"><path d="M7.1,13.3L3.8,10C3.4,9.6,3.4,8.9,3.8,8.5c0.4-0.4,1-0.4,1.4,0l1.9,1.9l4.4-4.4c0.4-0.4,1-0.4,1.4,0c0.4,0.4,0.4,1,0,1.4l-5.3,5.3C8.1,13.7,7.5,13.7,7.1,13.3z"/></svg>',
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.SizedBox(
                      width: width * 0.30,
                      height: height * 0.055,
                      child: pw.Image(image),
                    ),
                    pw.Text(
                      'DAILY ACCOMPLISHMENT REPORT',
                    ),
                  ],
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                    vertical: width * 0.06,
                  ),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      children: <pw.InlineSpan>[
                        pw.TextSpan(
                          text: 'Hello ',
                          style: textStyleMain,
                        ),
                        pw.TextSpan(
                          text: clientName,
                          style: textStyleBold,
                        ),
                        pw.TextSpan(
                          text:
                              '! For today’s update with worth 8 hours of work.',
                          style: textStyleMain,
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Column(
                  children: selectedTasks!.entries.map((
                    MapEntry<String, List<DSRWorks>> entry,
                  ) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: <pw.Widget>[
                        if (selectedTasks![entry.key]!.isNotEmpty)
                          pw.Container(
                            width: width,
                            padding: pw.EdgeInsets.only(bottom: width * 0.010),
                            margin: pw.EdgeInsets.symmetric(
                              vertical: width * 0.020,
                            ),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.grey,
                                ),
                              ),
                            ),
                            child: pw.Text(
                              _changeTabLabel(entry.key),
                              style: textStyleBold,
                            ),
                          ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: entry.value.map((DSRWorks value) {
                            return pw.Row(
                              mainAxisSize: pw.MainAxisSize.min,
                              children: <pw.Widget>[
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(width * 0.02),
                                  child: pw.Container(
                                    child: checkIcon,
                                    width: width * 0.09,
                                    height: width * 0.09,
                                  ),
                                ),
                                pw.Text(value.text, style: textStyleMain),
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
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: width * 0.06),
                  child: pw.RichText(
                    textAlign: pw.TextAlign.left,
                    text: pw.TextSpan(
                      children: <pw.InlineSpan>[
                        pw.TextSpan(
                          text: 'You can see detailed cards update in our',
                          style: textStyleMain,
                        ),
                        pw.TextSpan(
                          text: ' Asana ',
                          style: pw.TextStyle(
                            font: pw.Font.ttf(gilroyRegular),
                            lineSpacing: 1.8,
                            fontSize: height * 0.026,
                            fontFallback: <pw.Font>[
                              pw.Font.ttf(fontFamilyFallback)
                            ],
                            color: PdfColors.red,
                          ),
                        ),
                        pw.TextSpan(
                          text: 'board.',
                          style: textStyleMain,
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Text(
                  'Regards,',
                  style: textStyleMain,
                ),
                pw.Text(
                  'Karl from Nuxify',
                  style: textStyleBold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final Directory? directory = await _getAppDirectory();
    final String? appDirectory = directory?.path;
    final File file = File('${appDirectory}report.pdf');
    if (await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<Directory?> _getAppDirectory() async {
    Directory? appDirectory;
    if (kIsWeb) {
      appDirectory = Directory('');
    } else {
      if (Platform.isIOS) {
        appDirectory = Directory(
          '${Directory.current.path}/Documents/',
        );
      } else if (Platform.isAndroid) {
        if (await _isExternalStorageWritable()) {
          appDirectory = Directory('/storage/emulated/0/Download/');
        }
      }
    }
    return appDirectory;
  }

  Future<bool> _isExternalStorageWritable() async {
    final Directory directory = Directory('/storage/emulated/0/Download');
    try {
      final File file = File('${directory.path}/test.temp');
      await file.create();
      await file.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

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
                        alignment: PlaceholderAlignment.middle,
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
                    child:
                        BlocBuilder<AccomplishmentsCubit, AccomplishmentsState>(
                      builder:
                          (BuildContext context, AccomplishmentsState state) {
                        return FutureBuilder<File>(
                          future: generateDocument(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<File> snapshot,
                          ) {
                            if (snapshot.data == null) {
                              return Center(
                                child: LoadingIndicator(
                                  color: theme.primaryColor,
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<dynamic>(
                                      builder: (_) =>
                                          DailyAccomplishmentPDFScreen(
                                        clientName: clientName,
                                        document: snapshot.data!,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
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
                              );
                            }
                          },
                        );
                      },
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
