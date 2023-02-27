// initialize snackbarkey to be reusable even outside context
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Initialize snackbarkey to be reusable globally and even outside context
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

/// Provide globally manage snackbar
void showSnackBar({
  required String message,
  String? data,
  Duration? duration,
}) {
  final SnackBar snackBar = SnackBar(
    duration: duration ??
        const Duration(
          milliseconds: 4000,
        ), // Official default duration when not set.
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
    backgroundColor: Colors.green,
  );

  /// Trigger show snackbar using snackbarKey.
  snackbarKey.currentState?.showSnackBar(snackBar);
}
