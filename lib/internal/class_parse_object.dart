import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HolidayParseObject extends ParseObject implements ParseCloneable {
  HolidayParseObject() : super(_keyTableName);
  HolidayParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static HolidayParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as HolidayParseObject;

  /// Serialized response
  @override
  HolidayParseObject clone(Map<String, dynamic> map) =>
      HolidayParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'Holiday';
  static const String keyDate = 'date';
  static const String keyName = 'name';

  int get date => get<int>(keyDate)!;
  set date(int name) => set<int>(keyDate, name);

  String get name => get<String>(keyName)!;
  set name(String name) => set<String>(keyName, name);
}

class TimeInOutParseObject extends ParseObject implements ParseCloneable {
  TimeInOutParseObject() : super(_keyTableName);
  TimeInOutParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static TimeInOutParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as TimeInOutParseObject;

  /// Serialized response
  @override
  TimeInOutParseObject clone(Map<String, dynamic> map) =>
      TimeInOutParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'TimeInOut';
  static const String keyDate = 'date';
  static const String keyHoliday = 'holiday';

  int get date => get<int>(keyDate)!;
  set date(int date) => set<int>(keyDate, date);

  HolidayParseObject get holiday => get<HolidayParseObject>(keyHoliday)!;
  set holiday(HolidayParseObject holiday) =>
      set<HolidayParseObject>(keyHoliday, holiday);
}

class TimeAttendancesParseObject extends ParseObject implements ParseCloneable {
  TimeAttendancesParseObject() : super(_keyTableName);
  TimeAttendancesParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static TimeAttendancesParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as TimeAttendancesParseObject;

  /// Serialized response
  @override
  TimeAttendancesParseObject clone(Map<String, dynamic> map) =>
      TimeAttendancesParseObject.clone()..fromJson(map);

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

  TimeInOutParseObject get timeInOut =>
      get<TimeInOutParseObject>(keyTimeInOut)!;
  set timeInOut(TimeInOutParseObject timeInOut) =>
      set<TimeInOutParseObject>(keyTimeInOut, timeInOut);

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

class ProjectsParseObject extends ParseObject implements ParseCloneable {
  ProjectsParseObject() : super(_keyTableName);
  ProjectsParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static ProjectsParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as ProjectsParseObject;

  /// Serialized response
  @override
  ProjectsParseObject clone(Map<String, dynamic> map) =>
      ProjectsParseObject.clone()..fromJson(map);

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

class SprintsParseObject extends ParseObject implements ParseCloneable {
  SprintsParseObject() : super(_keyTableName);
  SprintsParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static SprintsParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as SprintsParseObject;

  /// Serialized response
  @override
  SprintsParseObject clone(Map<String, dynamic> map) =>
      SprintsParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'Sprints';
  static const String keyStartDate = 'start_date';
  static const String keyEndDate = 'end_date';

  int get startDate => get<int>(keyStartDate)!;
  set startDate(int startDate) => set<int>(keyStartDate, startDate);

  int get endDate => get<int>(keyEndDate)!;
  set endDate(int endDate) => set<int>(keyEndDate, endDate);
}

class DSRsParseObject extends ParseObject implements ParseCloneable {
  DSRsParseObject() : super(_keyTableName);
  DSRsParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static DSRsParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as DSRsParseObject;

  /// Serialized response
  @override
  DSRsParseObject clone(Map<String, dynamic> map) =>
      DSRsParseObject.clone()..fromJson(map);

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

  SprintsParseObject get sprints => get<SprintsParseObject>(keySprint)!;
  set sprints(SprintsParseObject sprints) =>
      set<SprintsParseObject>(keySprint, sprints);

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

class LeavesParseObject extends ParseObject implements ParseCloneable {
  LeavesParseObject() : super(_keyTableName);
  LeavesParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static LeavesParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as LeavesParseObject;

  /// Serialized response
  @override
  LeavesParseObject clone(Map<String, dynamic> map) =>
      LeavesParseObject.clone()..fromJson(map);

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

class LeavesRequestsParseObject extends ParseObject implements ParseCloneable {
  LeavesRequestsParseObject() : super(_keyTableName);
  LeavesRequestsParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static LeavesRequestsParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as LeavesRequestsParseObject;

  /// Serialized response
  @override
  LeavesRequestsParseObject clone(Map<String, dynamic> map) =>
      LeavesRequestsParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'LeavesRequests';
  static const String keyLeave = 'leave';
  static const String keyUser = 'user';
  static const String keyDateFilled = 'date_filed';
  static const String keyDateUsed = 'date_used';
  static const String keyStatus = 'status';
  static const String keyReason = 'reason';
  static const String keyLeaveType = 'leave_type';

  LeavesParseObject get leave => get<LeavesParseObject>(keyLeave)!;
  set leave(LeavesParseObject leave) => set<LeavesParseObject>(keyLeave, leave);

  ParseUser get user => get<ParseUser>(keyUser)!;
  set user(ParseUser user) => set<ParseUser>(keyUser, user);

  int get dateFiled => get<int>(keyDateFilled)!;
  set dateFiled(int dateFiled) => set<int>(keyDateFilled, dateFiled);

  int? get dateUsed => get<int>(keyDateUsed);
  set dateUsed(int? dateUsed) => set<int?>(keyDateUsed, dateUsed);

  String get status => get<String>(keyStatus)!;
  set status(String status) => set<String>(keyStatus, status);

  String get reason => get<String>(keyReason)!;
  set reason(String reason) => set<String>(keyReason, reason);

  String get leaveType => get<String>(keyLeaveType)!;
  set leaveType(String leaveType) => set<String>(keyLeaveType, leaveType);
}

class PanelRemindersParseObject extends ParseObject implements ParseCloneable {
  PanelRemindersParseObject() : super(_keyTableName);
  PanelRemindersParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static PanelRemindersParseObject toCustomParseObject(List<dynamic> data) =>
      (data as List<ParseObject?>).first! as PanelRemindersParseObject;

  /// Serialized response
  @override
  PanelRemindersParseObject clone(Map<String, dynamic> map) =>
      PanelRemindersParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'PanelReminders';
  static const String keyAnnouncement = 'announcement';
  static const String keyStartDate = 'start_date';
  static const String keyEndDate = 'end_date';
  static const String keyIsShow = 'is_show';

  int get startDate => get<int>(keyStartDate)!;
  set startDate(int startDate) => set<int>(keyStartDate, startDate);

  int get endDate => get<int>(keyEndDate)!;
  set endDate(int endDate) => set<int>(keyEndDate, endDate);

  bool get isShow => get<bool>(keyIsShow)!;
  set isShow(bool isShow) => set<bool>(keyIsShow, isShow);

  String get announcement => get<String>(keyAnnouncement)!;
  set announcement(String announcement) =>
      set<String>(keyAnnouncement, announcement);
}
