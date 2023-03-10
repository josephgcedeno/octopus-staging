import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/internal/helper_function.dart';
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

class TimeAttendances extends ParseObject implements ParseCloneable {
  TimeAttendances() : super(_keyTableName);
  TimeAttendances.clone() : this();

  /// Serialized response
  @override
  TimeAttendances clone(Map<String, dynamic> map) =>
      TimeAttendances.clone()..fromJson(map);

  static const String _keyTableName = 'TimeAttendances';
  static const String keyTimeIn = 'time_in';
  static const String keyTimeOut = 'time_out';
  static const String keyUser = 'user';
  static const String keyTimeInOut = 'time_in_out';
  static const String keyRequiredDuration = 'required_duration';
  static const String keyOffsetDuration = 'offset_duration';
  static const String keyOffsetStatus = 'offset_status';
  static const String keyOffsetToTime = 'offset_to_time';
  static const String keyOffsetReason = 'offset_reason';

  static const String keyOffsetFromTime = 'offset_from_time';

  int? get timeIn => get<int>(keyTimeIn);
  set timeIn(int? timeIn) => set<int?>(keyTimeIn, timeIn);

  int? get timeOut => get<int>(keyTimeOut);
  set timeOut(int? timeOut) => set<int?>(keyTimeOut, timeOut);

  ParseUser get user => get<ParseUser>(keyUser)!;
  set user(ParseUser user) => set<ParseUser>(keyUser, user);

  TimeInOut get timeInOut => get<TimeInOut>(keyTimeInOut)!;
  set timeInOut(TimeInOut timeInOut) => set<TimeInOut>(keyTimeInOut, timeInOut);

  int? get requiredDuration => get<int>(keyRequiredDuration);
  set requiredDuration(int? requiredDuration) =>
      set<int?>(keyRequiredDuration, requiredDuration);

  int? get offsetDuration => get<int>(keyOffsetDuration);
  set offsetDuration(int? offsetDuration) =>
      set<int?>(keyOffsetDuration, offsetDuration);

  String? get offsetStatus => get<String>(keyOffsetStatus);
  set offsetStatus(String? offsetStatus) =>
      set<String?>(keyOffsetStatus, offsetStatus);

  String? get offsetFromTime => get<String>(keyOffsetFromTime);
  set offsetFromTime(String? offsetFromTime) =>
      set<String?>(keyOffsetFromTime, offsetFromTime);

  String? get offsetToTime => get<String>(keyOffsetToTime);
  set offsetToTime(String? offsetToTime) =>
      set<String?>(keyOffsetToTime, offsetToTime);

  String? get offsetReason => get<String>(keyOffsetReason);
  set offsetReason(String? offsetReason) =>
      set<String?>(keyOffsetReason, offsetReason);
}

class Projects extends ParseObject implements ParseCloneable {
  Projects() : super(_keyTableName);
  Projects.clone() : this();

  /// Serialized response
  @override
  Projects clone(Map<String, dynamic> map) => Projects.clone()..fromJson(map);

  static const String _keyTableName = 'Projects';
  static const String keyDate = 'date';
  static const String keyName = 'name';
  static const String keyStatus = 'status';
  static const String keyColor = 'color';

  int get date => get<int>(keyDate)!;
  set date(int name) => set<int>(keyDate, name);

  String get name => get<String>(keyName)!;
  set name(String name) => set<String>(keyName, name);

  String get status => get<String>(keyStatus)!;
  set status(String status) => set<String>(keyStatus, status);

  String get color => get<String>(keyColor)!;
  set color(String color) => get<String>(keyColor)!;
}

class Sprints extends ParseObject implements ParseCloneable {
  Sprints() : super(_keyTableName);
  Sprints.clone() : this();

  /// Serialized response
  @override
  Sprints clone(Map<String, dynamic> map) => Sprints.clone()..fromJson(map);

  static const String _keyTableName = 'Sprints';
  static const String keyStartDate = 'start_date';
  static const String keyEndDate = 'end_date';

  int get startDate => get<int>(keyStartDate)!;
  set startDate(int startDate) => set<int>(keyStartDate, startDate);

  int get endDate => get<int>(keyEndDate)!;
  set endDate(int endDate) => set<int>(keyEndDate, endDate);
}

class DSRs extends ParseObject implements ParseCloneable {
  DSRs() : super(_keyTableName);
  DSRs.clone() : this();

  /// Serialized response
  @override
  DSRs clone(Map<String, dynamic> map) => DSRs.clone()..fromJson(map);

  static const String _keyTableName = 'DSRs';
  static const String keyUser = 'user';
  static const String keySprint = 'sprint';
  static const String keyDone = 'done';
  static const String keyWIP = 'work_in_progress';
  static const String keyBlockers = 'blockers';
  static const String keyDate = 'date';
  static const String keyStatus = 'status';

  ParseUser get user => get<ParseUser>(keyUser)!;
  set user(ParseUser user) => set<ParseUser>(keyUser, user);

  Sprints get sprints => get<Sprints>(keySprint)!;
  set sprints(Sprints sprints) => set<Sprints>(keySprint, sprints);

  List<Task>? get done =>
      convertListDynamic(get<List<dynamic>>(keyDone) ?? <dynamic>[]);
  set done(List<Task>? done) => set(keyDone, done);

  List<Task>? get wip =>
      convertListDynamic(get<List<dynamic>>(keyWIP) ?? <dynamic>[]);
  set wip(List<Task>? wip) => set(keyWIP, wip);

  List<Task>? get blockers =>
      convertListDynamic(get<List<dynamic>>(keyBlockers) ?? <dynamic>[]);
  set blockers(List<Task>? blockers) => set(keyBlockers, blockers);

  int get date => get<int>(keyDate)!;
  set date(int date) => set<int>(keyDate, date);

  String get status => get<String>(keyStatus)!;
  set status(String status) => set<String>(keyStatus, status);
}

class Leaves extends ParseObject implements ParseCloneable {
  Leaves() : super(_keyTableName);
  Leaves.clone() : this();

  /// Serialized response
  @override
  Leaves clone(Map<String, dynamic> map) => Leaves.clone()..fromJson(map);

  static const String _keyTableName = 'Leaves';
  static const String keyStartDate = 'start_date';
  static const String keyEndDate = 'end_date';
  static const String keyNoLeaves = 'no_leaves';

  int get startDate => get<int>(keyStartDate)!;
  set startDate(int startDate) => set<int>(keyStartDate, startDate);

  int get endDate => get<int>(keyEndDate)!;
  set endDate(int endDate) => set<int>(keyEndDate, endDate);

  int get noLeaves => get<int>(keyNoLeaves)!;
  set noLeaves(int noLeaves) => set<int>(keyNoLeaves, noLeaves);
}
