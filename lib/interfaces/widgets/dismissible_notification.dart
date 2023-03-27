import 'package:flutter/material.dart';

/// This will define the status of the notification to be shown.
///
/// [success] the background will be green.
///
/// [error] the background will be red
enum NotificationStatus { success, error }

/// This will show dismissible notification.
///
/// [context] build context of current screen.
///
/// [text] message that will be displayed.
///
/// [status] either success or error. Default is success.
///
/// [width] the width of the notification, by default 80% of the width.
Widget notification({
  required BuildContext context,
  required String text,
  NotificationStatus status = NotificationStatus.success,
  double? width,
}) {
  final ThemeData theme = Theme.of(context);
  final double widthDefault = MediaQuery.of(context).size.width;

  final Color isSuccess = status == NotificationStatus.success
      ? const Color(0xff9CDFE3)
      : const Color(0xffF0A8A8);

  return Dismissible(
    key: UniqueKey(),
    child: Card(
      color: isSuccess,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: width ?? widthDefault * 0.80,
        child: Text(
          text,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    ),
  );
}
