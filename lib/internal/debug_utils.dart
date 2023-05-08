// initialize snackbarkey to be reusable even outside context
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// This will be use to check if the status is listed in this enum.
///
/// [error] Show error color snackbar
///
/// [success] Show success color snackbar
enum SnackBartState { error, success }

/// Initialize snackbarkey to be reusable globally and even outside context
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

/// Provide globally manage snackbar.
///
/// [message] Message show in the left side of the snackar.
///
/// [snackBartState] The state to be shown with the snackbar.
///
/// [data] This will enable copy to clipboard action.
///
/// [duration] This will determine how long does the snackbar will be visible. Official default duration when not set is 4 seconds.
void showSnackBar({
  required String message,
  SnackBartState snackBartState = SnackBartState.success,
  Duration duration = const Duration(milliseconds: 4000),
  String? data,
}) {
  final SnackBar snackBar = SnackBar(
    duration: duration,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
            maxLines: 20,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (data != null)
          IconButton(
            padding: const EdgeInsets.only(left: 5),
            constraints: const BoxConstraints(),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: data,
                ),
              );
              snackbarKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.white,
              size: 20,
            ),
          ),
      ],
    ),
    backgroundColor:
        snackBartState == SnackBartState.success ? Colors.blue : kRed,
  );

  /// Trigger show snackbar using snackbarKey.
  snackbarKey.currentState?.showSnackBar(snackBar);
}

void formatAPIErrorResponse({required ParseError error}) {
  /// If code 1 means Successful request, but no results found.
  if (error.code == 1) return;

  /// FIXME: Temporary check on socket exception. Improve soon if better solution is available.
  if (error.exception.runtimeType.toString() == '_ClientSocketException') {
    throw APIErrorResponse.socketErrorResponse();
  }

  String errorMessage = error.message;
  String? errorCode = error.code.toString();

  /// Check if Error is not related to the listed one, it will always goes to code -1.
  if (error.code == -1) {
    errorMessage = 'Something wrong has happened. Try restarting the app.';
    errorCode = null;
  }

  throw APIErrorResponse(
    message: errorMessage,
    errorCode: errorCode,
  );
}
