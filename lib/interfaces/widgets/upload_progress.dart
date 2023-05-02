// ignore_for_file: always_specify_types, avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<String> uploadFile({
  required BuildContext context,
  required File file,
  String? fileName,
}) async {
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
                Stack(
                  children: <Widget>[
                    CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      strokeWidth: 10.0,
                      semanticsLabel: '${progress.toInt()}% uploaded',
                    ),
                    Center(
                      child: Text(
                        '${progress.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Uploading file...'),
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
}
