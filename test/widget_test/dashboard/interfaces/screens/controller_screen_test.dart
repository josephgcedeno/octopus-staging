// ignore_for_file: depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/dashboard_button.dart';
import 'package:octopus/module/hr_files/interfaces/screens/hr_files_screen.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_screen.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';
import 'package:octopus/module/standup_report/interfaces/screens/standup_report_screen.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';
import 'package:octopus/module/time_record/interfaces/screens/time_record_screen.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockTimeRecordCubit extends MockCubit<TimeRecordState>
    implements TimeRecordCubit {}

class MockDSRCubit extends MockCubit<DSRState> implements DSRCubit {}

class MockLeavesCubit extends MockCubit<LeavesState> implements LeavesCubit {}

void main() {
  late MockTimeRecordCubit mockTimeRecordCubit;
  late MockDSRCubit mockDSRCubit;
  late MockLeavesCubit mockLeavesCubit;

  void listenStub() {
    when(() => mockTimeRecordCubit.state).thenReturn(TimeRecordState());
    when(() => mockTimeRecordCubit.fetchAttendance()).thenAnswer((_) async {});
    when(() => mockLeavesCubit.state).thenReturn(LeavesState());
    when(() => mockLeavesCubit.fetchAllLeaves()).thenAnswer((_) async {});
    when(() => mockDSRCubit.state).thenReturn(const DSRState());
    when(() => mockDSRCubit.fetchCurrentDate()).thenAnswer((_) async {});
    when(() => mockDSRCubit.initializeDSR()).thenAnswer((_) async {});
    when(() => mockDSRCubit.getAllProjects()).thenAnswer((_) async {});
  }

  setUp(() {
    mockTimeRecordCubit = MockTimeRecordCubit();
    mockDSRCubit = MockDSRCubit();
    mockLeavesCubit = MockLeavesCubit();
  });
  tearDown(() {
    mockTimeRecordCubit.close();
    mockDSRCubit.close();
    mockLeavesCubit.close();
  });

  Future<void> pumpWidget(WidgetTester tester) async => tester.pumpWidget(
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<TimeRecordCubit>(
              create: (BuildContext context) => mockTimeRecordCubit,
            ),
            BlocProvider<DSRCubit>(
              create: (BuildContext context) => mockDSRCubit,
            ),
            BlocProvider<LeavesCubit>(
              create: (BuildContext context) => mockLeavesCubit,
            ),
          ],
          child: MaterialApp(
            scaffoldMessengerKey: snackbarKey,
            home: const Scaffold(
              body: ControllerScreen(),
            ),
          ),
        ),
      );

  group('Controller Screen', () {
    group('UI Components', () {
      testWidgets('Appbar should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(find.byType(GlobalAppBar), findsOneWidget);
      });

      testWidgets('Holiday indicators should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.text('Today is a special holiday.'),
          findsNWidgets(2),
        );
      });
      testWidgets('Tools label should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.text('Tools'),
          findsOneWidget,
        );
      });
      testWidgets('4 dashbord buttons should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.byType(DashboardButton),
          findsNWidgets(4),
        );
      });
      testWidgets('Daily Time Record button should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.text('Daily Time Record'),
          ),
          findsOneWidget,
        );
      });
      testWidgets('Daily Stand-Up Report button should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.text('Daily Stand-Up Report'),
          ),
          findsOneWidget,
        );
      });
      testWidgets('Leaves button should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.text('Leaves'),
          ),
          findsOneWidget,
        );
      });
      testWidgets('HR Files button should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.text('HR Files'),
          ),
          findsOneWidget,
        );
      });
      testWidgets('Daily Time Record icon should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.byIcon(Icons.timer_outlined),
          ),
          findsOneWidget,
        );
      });
      testWidgets('Daily Stand-Up Report icon should appear',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find
              .descendant(
                of: find.byType(DashboardButton),
                matching: find.byIcon(Icons.collections_bookmark_outlined),
              )
              .first,
          findsOneWidget,
        );
      });
      testWidgets('Leaves icon should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.byIcon(Icons.calendar_today_outlined),
          ),
          findsOneWidget,
        );
      });
      testWidgets('HR Files icon should appear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(DashboardButton),
            matching: find.byIcon(Icons.collections_bookmark_outlined).last,
          ),
          findsOneWidget,
        );
      });
    });
    group('Dashboard Functions', () {
      testWidgets(
          'When HR Files is clicked. It should navigate to HR Files screen',
          (WidgetTester tester) async {
        await pumpWidget(tester);

        await tester.pump();
        final Finder dashboardButton = find.ancestor(
          of: find.text('HR Files'),
          matching: find.byType(DashboardButton),
        );
        final Finder dashboardGuestureDetector = find.descendant(
          of: dashboardButton,
          matching: find.byType(GestureDetector),
        );

        expect(find.byType(ControllerScreen), findsOneWidget);
        expect(find.byType(HRFilesScreen), findsNothing);
        await tester.tap(dashboardGuestureDetector);
        await tester.pumpAndSettle();
        expect(find.byType(ControllerScreen), findsNothing);
        expect(find.byType(HRFilesScreen), findsOneWidget);
      });
      testWidgets('When Leaves is clicked. It should navigate to Leaves screen',
          (WidgetTester tester) async {
        listenStub();

        await pumpWidget(tester);
        await tester.pump();
        final Finder dashboardButton = find.ancestor(
          of: find.text('Leaves'),
          matching: find.byType(DashboardButton),
        );
        final Finder dashboardGuestureDetector = find.descendant(
          of: dashboardButton,
          matching: find.byType(GestureDetector),
        );
        expect(find.byType(ControllerScreen), findsOneWidget);
        expect(find.byType(LeavesScreen), findsNothing);
        await tester.tap(dashboardGuestureDetector);
        await tester.pumpAndSettle();
        expect(find.byType(ControllerScreen), findsNothing);
        expect(find.byType(LeavesScreen), findsOneWidget);
      });
      testWidgets(
          'When Daily Stand-Up Report is clicked. It should navigate to Daily Stand-Up Report screen',
          (WidgetTester tester) async {
        await pumpWidget(tester);
        listenStub();
        await tester.pump();
        final Finder dashboardButton = find.ancestor(
          of: find.text('Daily Stand-Up Report'),
          matching: find.byType(DashboardButton),
        );
        final Finder dashboardGuestureDetector = find.descendant(
          of: dashboardButton,
          matching: find.byType(GestureDetector),
        );
        expect(find.byType(ControllerScreen), findsOneWidget);
        expect(find.byType(StandupReportScreen), findsNothing);
        await tester.tap(dashboardGuestureDetector);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(ControllerScreen), findsNothing);
        expect(find.byType(StandupReportScreen), findsOneWidget);
      });
      //Not yet functional
      testWidgets(
          'When Daily Time Record is clicked. It should navigate to Daily Time Record screen',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues(<String, String>{});
        await Parse().initialize(
          'appId',
          'serverUrl',
          clientKey: 'clientKey',
          liveQueryUrl: 'liveQueryUrl',
          appName: 'appName',
          appPackageName: 'somePackageName',
          appVersion: 'someAppVersion',
          masterKey: 'masterKey',
          sessionId: 'sessionId',
          fileDirectory: 'someDirectory',
          debug: true,
        );
        await pumpWidget(tester);
        listenStub();
        await tester.pump();
        final Finder dashboardButton = find.ancestor(
          of: find.text('Daily Time Record'),
          matching: find.byType(DashboardButton),
        );
        final Finder dashboardGuestureDetector = find.descendant(
          of: dashboardButton,
          matching: find.byType(GestureDetector),
        );
        expect(find.byType(ControllerScreen), findsOneWidget);
        expect(find.byType(TimeRecordScreen), findsNothing);

        await tester.tap(dashboardGuestureDetector);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(ControllerScreen), findsNothing);
        expect(find.byType(TimeRecordScreen), findsOneWidget);
      });
    });
  });
}
