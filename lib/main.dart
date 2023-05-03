import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/repository/auth_repository.dart';
import 'package:octopus/infrastructures/repository/dsr_repository.dart';
import 'package:octopus/infrastructures/repository/leave_repository.dart';
import 'package:octopus/infrastructures/repository/project_repository.dart';
import 'package:octopus/infrastructures/repository/time_in_out_repository.dart';
import 'package:octopus/interfaces/screens/splash_screen.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';
import 'package:octopus/module/login/interfaces/screens/login_screen.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load env file
  await dotenv.load();

  final String appId = dotenv.get('APP_ID');
  final String serverUrl = dotenv.get('SERVER_URL');
  final String masterKey = dotenv.get('MASTER_KEY');

  final String liveQueryUrl = 'ws://${serverUrl.split('/')[2]}/';

  await Parse().initialize(
    appId,
    serverUrl,
    masterKey: masterKey,
    liveQueryUrl: liveQueryUrl,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AuthRepository authRepository = AuthRepository();
  final TimeInOutRepository timeInOutRepository = TimeInOutRepository();
  final DSRRepository dsrRepository = DSRRepository();
  final ProjectRepository projectRepository = ProjectRepository();
  final LeaveRepository leaveRepository = LeaveRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthenticationCubit>(
          create: (_) => AuthenticationCubit(authRepository: authRepository),
        ),
        BlocProvider<DSRCubit>(
          create: (_) => DSRCubit(
            dsrRepository: dsrRepository,
            projectRepository: projectRepository,
          ),
        ),
        BlocProvider<TimeRecordCubit>(
          create: (BuildContext context) => TimeRecordCubit(
            timeInOutRepository: timeInOutRepository,
          ),
        ),
        BlocProvider<LeavesCubit>(
          create: (BuildContext context) => LeavesCubit(
            leaveRepository: leaveRepository,
          ),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        title: dotenv.get('TITLE'),
        home: _HomePageState(),
        theme: defaultTheme,
        supportedLocales: const <Locale>[
          Locale('en'),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _HomePageState extends StatefulWidget {
  @override
  State<_HomePageState> createState() => _HomePageStateState();
}

class _HomePageStateState extends State<_HomePageState> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().validateToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (AuthenticationState previous, AuthenticationState current) =>
          current is ValidateTokenSuccess || current is ValidateTokenFailed,
      listener: (BuildContext context, AuthenticationState state) {
        if (state is ValidateTokenSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const ControllerScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is ValidateTokenFailed) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const LoginScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: const SplashScreen(),
    );
  }
}
