import 'dart:io';
import 'dart:math';

import 'package:download/download.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DailyAccomplishmentPDFScreen extends StatefulWidget {
  const DailyAccomplishmentPDFScreen({
    required this.clientName,
    required this.document,
    Key? key,
  }) : super(key: key);

  final String clientName;
  final File document;

  @override
  State<DailyAccomplishmentPDFScreen> createState() =>
      _DailyAccomplishmentPDFScreenState();
}

class _DailyAccomplishmentPDFScreenState
    extends State<DailyAccomplishmentPDFScreen> {
  late Map<String, List<DSRWorks>>? selectedTasks =
      context.read<AccomplishmentsCubit>().state.selectedTasks;

  bool isDownloading = false;
  bool isLoading = true;
  bool isLoadingFailed = false;

  final int loaderItems = 13;

  Future<void> sharePDF() async {
    try {
      if (kIsWeb) {
        await Share.shareXFiles(
          <XFile>[XFile(widget.document.path)],
          subject: 'Nuxify Report',
        );
      } else {
        await Share.shareFiles(
          <String>[widget.document.path],
          subject: 'Nuxify Report',
        );
      }
    } on PlatformException catch (e) {
      showSnackBar(
          message: 'Error detected: $e', snackBartState: SnackBartState.error,);
    }
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

  Stream<int> fileToStream(File file) {
    return file.openRead().expand((List<int> bytes) => bytes);
  }

  Future<void> downloadPDF(String title, File file) async {
    try {
      setState(() {
        isDownloading = true;
      });
      final Stream<int> stream = fileToStream(file);
      final String fileName = (title.replaceAll(' ', '-')).toLowerCase();
      final Directory? directory = await _getAppDirectory();
      final String? appDirectory = directory?.path;
      await download(stream, '$appDirectory$fileName.pdf');
      showSnackBar(message: 'File downloaded successfully');
      setState(() {
        isDownloading = false;
      });
    } catch (error) {
      showSnackBar(
        message: error.toString(),
        snackBartState: SnackBartState.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
          GestureDetector(
            onTap: sharePDF,
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: const Icon(
                Icons.share_outlined,
                color: kLightBlack,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => downloadPDF('report', widget.document),
            child: Container(
              margin: EdgeInsets.only(
                right: width * 0.03,
              ),
              height: height * 0.0003,
              padding: EdgeInsets.symmetric(
                horizontal: isPortrait ? 0 : width * 0.040,
                vertical: isPortrait ? 0 : width * 0.03,
              ),
              child: isDownloading
                  ? const Center(
                      child: LoadingIndicator(
                        color: kLightBlack,
                      ),
                    )
                  : const Icon(
                      Icons.file_download_outlined,
                      color: kLightBlack,
                      size: 25,
                    ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: <Widget>[
                  SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                      progressBarColor: ktransparent,
                    ),
                    child: SfPdfViewer.file(
                      widget.document,
                      onDocumentLoaded: (_) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onDocumentLoadFailed: (_) {
                        setState(() {
                          isLoadingFailed = true;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Container(
                      width: double.infinity,
                      color: kLightGrey,
                      padding: EdgeInsets.all(width * 0.035),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (int i = 0; i < loaderItems; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.008,
                                horizontal: width * 0.025,
                              ),
                              child: lineLoader(
                                height: Random().nextInt(15) + 10,
                                width: double.infinity,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoadingFailed,
                    child: Container(
                      width: double.infinity,
                      color: kLightGrey,
                      padding: EdgeInsets.all(width * 0.035),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(height * 0.015),
                            child: const Icon(
                              Icons.error_outline_outlined,
                            ),
                          ),
                          const Text('Document failed to load'),
                        ],
                      ),
                    ),
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
