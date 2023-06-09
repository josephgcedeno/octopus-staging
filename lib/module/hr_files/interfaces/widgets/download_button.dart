import 'dart:io';

import 'package:download/download.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:path_provider/path_provider.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    required this.title,
    required this.url,
    required this.documentLoading,
    Key? key,
  }) : super(key: key);

  final String title;
  final String url;
  final bool documentLoading;
  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;

  Future<void> downloadPDF(String title, String url) async {
    try {
      setState(() {
        isDownloading = true;
      });
      final http.Response response = await http.get(Uri.parse(url));
      final Stream<int> stream = Stream<int>.fromIterable(response.bodyBytes);
      final String fileName = (title.replaceAll(' ', '-')).toLowerCase();
      final Directory? directory = await _getAppDirectory();
      final String? appDirectory = directory?.path;
      await download(stream, '$appDirectory$fileName.pdf');
      showSnackBar(message: 'File downloaded successfully');
      setState(() {
        isDownloading = false;
      });
    } catch (error) {
      setState(() {
        isDownloading = false;
      });
      showSnackBar(
        message: error.toString(),
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
        final Directory documents = await getApplicationDocumentsDirectory();
        appDirectory = Directory(
          '${documents.path}/Documents',
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
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (!widget.documentLoading) {
          downloadPDF(
            widget.title,
            widget.url,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isDownloading
            ? SizedBox(
                height: height * 0.03,
                width: height * 0.03,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: kDarkGrey,
                ),
              )
            : Icon(
                Icons.file_download_outlined,
                color: widget.documentLoading ? Colors.grey : null,
              ),
      ),
    );
  }
}
