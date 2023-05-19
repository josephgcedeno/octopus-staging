import 'dart:io';
import 'package:download/download.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({
    required this.pdf,
    Key? key,
  }) : super(key: key);

  final Uint8List pdf;

  Future<void> sharePDF() async {
    try {
      Share.shareXFiles(
        <XFile>[
          XFile.fromData(
            pdf,
            mimeType: 'application/pdf',
            name: 'Daily Report',
          )
        ],
        subject: 'Nuxify Report',
      ).catchError((Object e) async {
        showSnackBar(
          message: 'Error when sharing file.',
          snackBartState: SnackBartState.error,
          data: e.toString(),
        );
        return const ShareResult(
          'Error when sharing file.',
          ShareResultStatus.unavailable,
        );
      });
    } on PlatformException catch (e) {
      showSnackBar(
        message: 'Error detected: $e',
        snackBartState: SnackBartState.error,
      );
    }
  }

  Future<Directory?> _getAppDirectory() async {
    Directory? appDirectory;
    if (kIsWeb) {
      appDirectory = Directory('');
    } else {
      if (Platform.isIOS) {
        appDirectory = await getApplicationDocumentsDirectory();
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

  Future<void> downloadPDF(String title, Uint8List file) async {
    try {
      final Stream<int> stream = Stream<int>.fromIterable(file);
      final String fileName = (title.replaceAll(' ', '-')).toLowerCase();
      final Directory? directory = await _getAppDirectory();
      final String? appDirectory = directory?.path;

      await download(stream, '$appDirectory$fileName.pdf');
      showSnackBar(message: 'File downloaded successfully $appDirectory');
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
            onTap: () => downloadPDF('report', pdf),
            child: Container(
              margin: EdgeInsets.only(
                right: width * 0.04,
              ),
              height: height * 0.0003,
              child: const Icon(
                Icons.file_download_outlined,
                color: kLightBlack,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(
          progressBarColor: ktransparent,
        ),
        child: SfPdfViewer.memory(pdf),
      ),
    );
  }
}
