import 'dart:io';

import 'package:download/download.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DailyAccomplishmentPDFScreen extends StatefulWidget {
  const DailyAccomplishmentPDFScreen({
    required this.clientName,
    required this.document,
    Key? key,
  }) : super(key: key);

  final String clientName;
  final Future<File> document;

  @override
  State<DailyAccomplishmentPDFScreen> createState() =>
      _DailyAccomplishmentPDFScreenState();
}

class _DailyAccomplishmentPDFScreenState
    extends State<DailyAccomplishmentPDFScreen> {
  late Map<String, List<DSRWorks>>? selectedTasks =
      context.read<AccomplishmentsCubit>().state.selectedTasks;

  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
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
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: const Icon(
              Icons.share_outlined,
              color: kLightBlack,
              size: 20,
            ),
          ),
          GestureDetector(
            onTap: () => downloadPDF('report', ''),
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: isDownloading
                  ? SizedBox(
                      height: height * 0.03,
                      width: height * 0.03,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: kDarkGrey,
                      ),
                    )
                  : const Icon(
                      Icons.file_download_outlined,
                      color: kLightBlack,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: FutureBuilder<File>(
              future: widget.document,
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.data != null) {
                  return SfPdfViewer.file(snapshot.data!);
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
