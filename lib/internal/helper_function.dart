import 'package:flutter_baas_parse/infastructures/models/dsr/dsr_request.dart';

int epochFromDateTime({required DateTime date}) => date.millisecondsSinceEpoch;

DateTime dateTimeFromEpoch({required int epoch}) =>
    DateTime.fromMillisecondsSinceEpoch(epoch);

String printDurationFrom(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String hourFormatFromSeconds(int value) {
  int h, m, s;

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  String result =
      "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";

  return result;
}

/// For converting dynamic list to desired list.
List<DSRWorkTrack> convertListDynamic(List<dynamic> datas) {
  final List<DSRWorkTrack> convertedData = <DSRWorkTrack>[];
  for (var data in datas) {
    convertedData.add(DSRWorkTrack.fromJson(data));
  }
  return convertedData;
}
