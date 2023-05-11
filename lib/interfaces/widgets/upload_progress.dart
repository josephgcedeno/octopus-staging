// ignore_for_file: always_specify_types, avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

typedef UploadStringFunction = Future<String> Function({
  required BuildContext context,
  required File file,
  String? fileName,
});

class PdfGenerationDialog extends StatelessWidget {
  const PdfGenerationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text('Generating PDF'),
        content: Row(
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text('Please wait...'),
          ],
        ),
      ),
    );
  }
}

UploadStringFunction uploadFile = ({
  required BuildContext context,
  required File file,
  String? fileName,
}) async {
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0);

  double progress = 0;
  dynamic setState1;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          setState1 = setState;
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 75,
                  height: 75,
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            child: ValueListenableBuilder(
                              valueListenable: progressNotifier,
                              builder: (context, double value, _) {
                                return CircularProgressIndicator(
                                  value: value,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    value < 0.5
                                        ? Colors.green
                                        : value > 0.8
                                            ? Colors.greenAccent
                                            : Colors.green.shade400,
                                  ),
                                  backgroundColor: Colors.grey[300],
                                  strokeWidth: 10.0,
                                  semanticsLabel:
                                      '${(value * 100).toInt()}% uploaded',
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: constrains.maxWidth * 0.90,
                            height: constrains.maxHeight * 0.90,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${progress.toInt()}%',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: progress > 90
                                        ? Colors.green
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text('Uploading file...'),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  final ParseFile parseFile = ParseFile(file);

  if (fileName != null) parseFile.name = fileName;

  final ParseResponse uploadResponse = await parseFile.upload(
    progressCallback: (int count, int total) {
      setState1(() {
        progress = (count / total) * 100;
        progressNotifier.value = progress / 100;
      });
    },
  );

  /// After upload, just close the progress.
  Future<void>.delayed(
    const Duration(milliseconds: 500),
    () => Navigator.of(context).pop(),
  );

  if (uploadResponse.error != null) {
    formatAPIErrorResponse(error: uploadResponse.error!);
  }

  if (uploadResponse.success) {
    final ParseObject uploadResponseResult =
        uploadResponse.result as ParseObject;
    return uploadResponseResult.get<String>('url')!;
  }

  throw errorSomethingWentWrong;
};
