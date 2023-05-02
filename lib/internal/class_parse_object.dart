import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HolidayParseObject extends ParseObject implements ParseCloneable {
  HolidayParseObject() : super(_keyTableName);
  HolidayParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static HolidayParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as HolidayParseObject;

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
  static TimeInOutParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as TimeInOutParseObject;

  /// This function will be used to manually override the default conversion of ParseObject to custom parse object.
  @override
  TimeInOutParseObject fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey(keyHoliday)) {
      holiday = HolidayParseObject.clone()
        ..fromJson(objectData[keyHoliday] as Map<String, dynamic>);
    }
    return this;
  }

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
  static TimeAttendancesParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as TimeAttendancesParseObject;

  /// This function will be used to manually override the default conversion of ParseObject to custom parse object.
  @override
  TimeAttendancesParseObject fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey(keyTimeInOut)) {
      timeInOut = TimeInOutParseObject.clone()
        ..fromJson(objectData[keyTimeInOut] as Map<String, dynamic>);
    }
    return this;
  }

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
  static ProjectsParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as ProjectsParseObject;

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
  set color(String color) => set<String>(keyColor, color);
}

class SprintsParseObject extends ParseObject implements ParseCloneable {
  SprintsParseObject() : super(_keyTableName);
  SprintsParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static SprintsParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as SprintsParseObject;

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

  /// This function will be used to manually override the default conversion of ParseObject to custom parse object.
  @override
  DSRsParseObject fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey(keySprint)) {
      sprints = SprintsParseObject.clone()
        ..fromJson(objectData[keySprint] as Map<String, dynamic>);
    }
    return this;
  }

  /// Convert the ParseObject to a custom parse object.
  static DSRsParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as DSRsParseObject;

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
  static LeavesParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as LeavesParseObject;

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

  /// This function will be used to manually override the default conversion of ParseObject to custom parse object.
  @override
  LeavesRequestsParseObject fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey(keyLeave)) {
      leave = LeavesParseObject.clone()
        ..fromJson(objectData[keyLeave] as Map<String, dynamic>);
    }
    return this;
  }

  /// Convert the ParseObject to a custom parse object.
  static LeavesRequestsParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as LeavesRequestsParseObject;

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
  static const String keyLeaveDateFrom = 'leave_date_from';
  static const String keyLeaveDateTo = 'leave_date_to';

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

  int get leaveDateFrom => get<int>(keyLeaveDateFrom)!;
  set leaveDateFrom(int from) => set<int>(keyLeaveDateFrom, from);

  int get leaveDateTo => get<int>(keyLeaveDateTo)!;
  set leaveDateTo(int to) => set<int>(keyLeaveDateTo, to);
}

class PanelRemindersParseObject extends ParseObject implements ParseCloneable {
  PanelRemindersParseObject() : super(_keyTableName);
  PanelRemindersParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static PanelRemindersParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as PanelRemindersParseObject;

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

class EmployeeInfoParseObject extends ParseObject implements ParseCloneable {
  EmployeeInfoParseObject() : super(_keyTableName);
  EmployeeInfoParseObject.clone() : this();

  /// Convert the ParseObject to a custom parse object.
  static EmployeeInfoParseObject toCustomParseObject({
    required dynamic data,
  }) =>
      data as EmployeeInfoParseObject;

  /// Serialized response
  @override
  EmployeeInfoParseObject clone(Map<String, dynamic> map) =>
      EmployeeInfoParseObject.clone()..fromJson(map);

  static const String _keyTableName = 'EmployeeInfo';

  // Field names with snake case
  static const String keyUser = 'user';
  static const String keyFirstName = 'first_name';
  static const String keyLastName = 'last_name';
  static const String keyNuxifyId = 'nuxify_id';
  static const String keyBirthDate = 'birth_date';
  static const String keyAddress = 'address';
  static const String keyCivilStatus = 'civil_status';
  static const String keyDateHired = 'date_hired';
  static const String keyProfileImageSource = 'profile_image_source';
  static const String keyPosition = 'position';
  static const String keyPagIbigNo = 'pag_ibig_no';
  static const String keySssNo = 'sss_no';
  static const String keyTinNo = 'tin_no';
  static const String keyPhilHealthNo = 'phil_health_no';
  static const String keyIsDeactive = 'is_deactive';

  ParseUser get user => get<ParseUser>(keyUser)!;
  set user(ParseUser user) => set<ParseUser>(keyUser, user);

  String get firstName => get<String>(keyFirstName)!;
  set firstName(String value) => set<String>(keyFirstName, value);

  String get lastName => get<String>(keyLastName)!;
  set lastName(String value) => set<String>(keyLastName, value);

  String get nuxifyId => get<String>(keyNuxifyId)!;
  set nuxifyId(String value) => set<String>(keyNuxifyId, value);

  int get birthDateEpoch => get<int>(keyBirthDate)!;
  set birthDateEpoch(int value) => set<int>(keyBirthDate, value);

  String get address => get<String>(keyAddress)!;
  set address(String value) => set<String>(keyAddress, value);

  String get civilStatus => get<String>(keyCivilStatus)!;
  set civilStatus(String value) => set<String>(keyCivilStatus, value);

  int get dateHiredEpoch => get<int>(keyDateHired)!;
  set dateHiredEpoch(int value) => set<int>(keyDateHired, value);

  String get profileImageSource => get<String>(keyProfileImageSource)!;
  set profileImageSource(String value) =>
      set<String>(keyProfileImageSource, value);

  String get position => get<String>(keyPosition)!;
  set position(String value) => set<String>(keyPosition, value);

  String get pagIbigNo => get<String>(keyPagIbigNo)!;
  set pagIbigNo(String value) => set<String>(keyPagIbigNo, value);

  String get sssNo => get<String>(keySssNo)!;
  set sssNo(String value) => set<String>(keySssNo, value);

  String get tinNo => get<String>(keyTinNo)!;
  set tinNo(String value) => set<String>(keyTinNo, value);

  String get philHealthNo => get<String>(keyPhilHealthNo)!;
  set philHealthNo(String value) => set<String>(keyPhilHealthNo, value);

  bool get isDeactive => get<bool>(keyIsDeactive)!;
  set isDeactive(bool value) => set<bool>(keyIsDeactive, value);
}
