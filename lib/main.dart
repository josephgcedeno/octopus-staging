import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/repository/auth_repository.dart';
import 'package:octopus/infrastructures/repository/time_in_out_repository.dart';
import 'package:octopus/module/login/service/cubit/login_cubit.dart';
import 'package:octopus/module/time_record/interfaces/screens/time_record_screen.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load env file
  await dotenv.load();

  final String appId = dotenv.get('APP_ID');
  final String serverUrl = dotenv.get('SERVER_URL');
  final String masterKey = dotenv.get('MASTER_KEY');

  await Parse().initialize(
    appId,
    serverUrl,
    masterKey: masterKey,
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

  Future<void> initializeData() async {
    /// Create daily record.
    await timeInOutRepository.createNewDate();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LoginCubit>(
          create: (BuildContext context) =>
              LoginCubit(authRepository: authRepository),
        ),
        BlocProvider<TimeRecordCubit>(
          create: (BuildContext context) => TimeRecordCubit(
            timeInOutRepository: timeInOutRepository,
          ),
        ),
      ],
      child: MaterialApp(
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

class _HomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const TimeRecordScreen();
  }
}
