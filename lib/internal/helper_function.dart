import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

/// Get the id of the ParseObject in a list of dynamic
String getResultId(List<dynamic> data) =>
    ((data as List<ParseObject?>).first)!.objectId!;

/// Get the whole ParseObject in a list of dynamic
ParseObject getParseObject(List<dynamic> data) =>
    (data as List<ParseObject?>).first!;

int epochFromDateTime({required DateTime date}) => date.millisecondsSinceEpoch;

DateTime dateTimeFromEpoch({required int epoch}) =>
    DateTime.fromMillisecondsSinceEpoch(epoch);

String printDurationFrom(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String hourFormatFromSeconds(int value) {
  int h;
  int m;
  int s;

  h = value ~/ 3600;

  m = (value - h * 3600) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  final String result =
      "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";

  return result;
}

/// For converting dynamic list to desired list.
List<Task> convertListDynamic(List<dynamic> datas) {
  final List<Task> convertedData = <Task>[];

  for (final dynamic data in datas) {
    final Map<String, dynamic> parseTask = data as Map<String, dynamic>;
    convertedData.add(Task.fromJson(parseTask));
  }
  return convertedData;
}
