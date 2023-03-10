import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Holiday extends ParseObject implements ParseCloneable {
  Holiday() : super(_keyTableName);
  Holiday.clone() : this();

  /// Serialized response
  @override
  Holiday clone(Map<String, dynamic> map) => Holiday.clone()..fromJson(map);

  static const String _keyTableName = 'Holiday';
  static const String keyDate = 'date';
  static const String keyName = 'name';

  int get date => get<int>(keyDate)!;
  set date(int name) => set<int>(keyDate, name);

  String get name => get<String>(keyName)!;
  set name(String name) => set<String>(keyName, name);
}

class TimeInOut extends ParseObject implements ParseCloneable {
  TimeInOut() : super(_keyTableName);
  TimeInOut.clone() : this();

  /// Serialized response
  @override
  TimeInOut clone(Map<String, dynamic> map) => TimeInOut.clone()..fromJson(map);

  static const String _keyTableName = 'TimeInOut';
  static const String keyDate = 'date';
  static const String keyHoliday = 'holiday';

  int get date => get<int>(keyDate)!;
  set date(int date) => set<int>(keyDate, date);

  Holiday get holiday => get<Holiday>(keyHoliday)!;
  set holiday(Holiday holiday) => set<Holiday>(keyHoliday, holiday);
}
