import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({required this.title, required this.icon, Key? key})
      : super(key: key);

  final String title;
  final IconData icon;

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool isLoading = true;
  bool isNotLoading = false;

  Future<void> downloadPDF(String url) async {
    try {
      final Directory? directory = await _getAppDirectory();
      final String? appDirectory = directory?.path;

      final Dio dio = Dio();
      final String fileName = (widget.title.replaceAll(' ', '-')).toLowerCase();

      await dio.download(
        url,
        '$appDirectory/$fileName.pdf',
        onReceiveProgress: (int receivedBytes, int totalBytes) {},
      );

      showSnackBar(message: 'File downloaded successfully');
    } catch (error) {
      showSnackBar(
        message: error.toString(),
        snackBartState: SnackBartState.error,
      );
    }
  }

  Future<Directory?> _getAppDirectory() async {
    Directory? appDirectory;
    if (kIsWeb) {
      appDirectory = Directory('/Downloads');
    } else {
      if (Platform.isIOS) {
        appDirectory = Directory(
          '${Directory.current.path}/Documents',
        );
      } else if (Platform.isAndroid) {
        if (await _isExternalStorageWritable()) {
          appDirectory = Directory('/storage/emulated/0/Download');
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

    const int loaderItems = 13;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.055,
                vertical: height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(widget.icon),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.03),
                        child: Text(
                          widget.title,
                          style: kIsWeb
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      downloadPDF(
                        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                      ); // pdf file URL
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.015),
                      decoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.file_download_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                      progressBarColor: ktransparent,
                    ),
                    child: SfPdfViewer.network(
                      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf', // pdf file URL
                      onDocumentLoaded: (_) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onDocumentLoadFailed: (_) {
                        setState(() {
                          isNotLoading = true;
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
                    visible: isNotLoading,
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
          ],
        ),
      ),
    );
  }
}
