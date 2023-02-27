// initialize snackbarkey to be reusable even outside context
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octopus/configs/themes.dart';

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
        snackBartState == SnackBartState.success ? Colors.green : kRed,
  );

  /// Trigger show snackbar using snackbarKey.
  snackbarKey.currentState?.showSnackBar(snackBar);
}
