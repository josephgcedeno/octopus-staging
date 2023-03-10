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
