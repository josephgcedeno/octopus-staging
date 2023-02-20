import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/repository/auth_repository.dart';
import 'package:octopus/infrastructures/repository/dsr_repository.dart';
import 'package:octopus/interfaces/screens/splash_screen.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/login/interfaces/screens/login_screen.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';
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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    final DSRRepository dsrRepository = DSRRepository();

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthenticationCubit>(
          create: (_) => AuthenticationCubit(authRepository: authRepository),
        ),
        BlocProvider<DSRCubit>(
          create: (_) => DSRCubit(dsrRepository: dsrRepository),
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
