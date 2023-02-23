/// Database Class/Tables
const String timeInOutsTable = 'time_in_outs';
const String timeAttendancesTable = 'time_attendances';
const String projectTagsTable = 'project_tags';
const String sprintsTable = 'sprints';
const String dsrsTable = 'dsrs';
const String thirdPartyAccountsTable = 'third_party_accounts';
const String thirdPartyAccountAccessTable = 'third_paty_account_access';
const String panelRemindersTable = 'panel_reminders';
const String kpiPathsTable = 'kpi_paths';
const String leavesTable = 'leaves';
const String extraLeavesTable = 'extra_leaves';
const String leaveRequestsTable = 'leave_requests';
const String holidaysTable = 'holidays';
const String usersTable = '_User';

/// Database Properties/Fields
/// For user table
const String usersNameField = 'name';
const String usersPositionField = 'position';
const String usersIsAdminField = 'is_admin';
const String usersPhotoField = 'photo';

/// For time_in_outs table
const String timeInOutsHolidayIdField = 'holiday_id';
const String timeInOutDateField = 'date';

/// For time_attendances table
const String timeAttendancesTimeInField = 'time_in';
const String timeAttendancesTimeOutField = 'time_out';
const String timeAttendancesUserIdField = 'user_id';
const String timeAttendancesTimeInOutIdField = 'time_in_out_id';
const String timeAttendancesOffsetDurationField = 'offset_duration';
const String timeAttendancesOffsetStatusField = 'offset_status';
const String timeAttendancesRequiredDurationField = 'required_duration';

/// For dsrs table
const String dsrsSprintidField = 'sprint_id';
const String dsrsDateField = 'date';
const String dsrsUserIdField = 'user_id';
const String dsrsDoneField = 'done';
const String dsrsWipField = 'work_in_progress';
const String dsrsBlockersField = 'blockers';
const String dsrsStatusField = 'status';

/// For project tags table
const String projectTagsProjectNameField = 'project_name';
const String projectTagsProjectDateField = 'date';
const String projectTagsProjectStatusField = 'status';
const String projectTagsProjectColorField = 'color';

/// For sprints table
const String sprintsStartDateField = 'start_date';
const String sprintsEndDateField = 'end_date';
const String sprintsProjectIdsField = 'projects_tag_ids';

/// For panel reminders
const String pannelRemindersAnnouncementField = 'announcement';
const String pannelRemindersStartDateField = 'start_date';
const String pannelRemindersEndDateField = 'end_date';
const String pannelRemindersIsShowField = 'is_show';

/// For leaves table
const String leavesNoLeavesField = 'no_leaves';
const String leavesStartDateField = 'start_date';
const String leavesEndDateField = 'end_date';

/// For leave request
const String leaveRequestLeaveIdField = 'leave_id';
const String leaveRequestUserIdField = 'user_id';
const String leaveRequestDateFiledField = 'date_filed';
const String leaveRequestDateUsedField = 'date_used';
const String leaveRequestStatusField = 'status';
const String leaveRequestReasonField = 'reason';
const String leaveRequestLeaveTypeField = 'leave_type';

/// For holiday table
const String holidayNameField = 'holiday_name';
const String holidayDateField = 'date';
