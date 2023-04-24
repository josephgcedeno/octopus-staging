import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/login/interfaces/screens/login_screen.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';

class MockAuthenticationCubit extends MockCubit<AuthenticationState>
    implements AuthenticationCubit {}

void main() {
  late MockAuthenticationCubit mockAuthenticationCubit;
  void listenStub() {
    when(() => mockAuthenticationCubit.state)
        .thenReturn(const AuthenticationState());
    // when(() => mockQuoteCubit.fetchQuote()).thenAnswer((_) async {});
  }

  setUp(() {
    mockAuthenticationCubit = MockAuthenticationCubit();
  });
  tearDown(() {
    mockAuthenticationCubit.close();
  });
  Future<void> pumpWidget(WidgetTester tester) async => tester.pumpWidget(
        BlocProvider<AuthenticationCubit>(
          create: (BuildContext context) => mockAuthenticationCubit,
          child: MaterialApp(
            scaffoldMessengerKey: snackbarKey,
            home: const Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );
  group('Login Screen', () {
    group('UI Components', () {
      testWidgets('Logo should appear', (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();
        expect(find.byType(SvgPicture), findsOneWidget);
      });
      const String loginMessage = "Hi there!\nLet's get you prepared.";
      testWidgets('Login message should apear', (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        //finds a widget that is a RichText and is equal to loginMessage when converted to plain text
        final Finder loginMessageRichText = find.byWidgetPredicate(
          (Widget widget) =>
              widget is RichText && widget.text.toPlainText() == loginMessage,
        );

        expect(
          loginMessageRichText,
          findsOneWidget,
        );
      });
      testWidgets('Email label should appear', (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        final Finder emailText = find.text('Email');

        expect(
          emailText,
          findsOneWidget,
        );
      });
      testWidgets('Password label should appear', (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        final Finder emailText = find.text('Password');

        expect(
          emailText,
          findsOneWidget,
        );
      });
      testWidgets('Email and password textfield should appear',
          (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        final Finder textFields = find.byType(TextFormField);

        expect(
          textFields,
          findsNWidgets(2),
        );
      });
      testWidgets('Forgotten? text button should appear',
          (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        final Finder forgottenButton = find.ancestor(
            of: find.text('Forgotten?'),
            matching: find.byType(GestureDetector),);

        expect(
          forgottenButton,
          findsOneWidget,
        );
      });

      testWidgets('Sign In Button should appear', (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();

        //finds a widget that is a RichText and is equal to loginMessage when converted to plain text

        final Finder loginButtonText = find.text('Sign In');
        final Finder loginButton = find.ancestor(
          of: loginButtonText,
          matching: find.byType(ElevatedButton),
        );
        expect(
          loginButtonText,
          findsOneWidget,
        );
        expect(
          loginButton,
          findsOneWidget,
        );
      });
    });

    group('Login Function.', () {
      const String errorEmptyeEmail = 'Please enter your email.';
      const String errorEmptyPassword = 'Please enter your password.';
      testWidgets(
          'When entering empty email & password on text field and should error $errorEmptyPassword & $errorEmptyeEmail,',
          (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();
        final Finder textFields = find.byType(TextFormField);
        final Finder emailTextField = textFields.first;
        final Finder passwordTextField = textFields.last;
        expect(textFields, findsNWidgets(2));
        await tester.enterText(emailTextField, '');
        await tester.enterText(passwordTextField, '');
        await tester.pump();
        final Finder signInBtn = find.ancestor(
          of: find.text('Sign In'),
          matching: find.byType(ElevatedButton),
        );
        expect(signInBtn, findsOneWidget);
        expect(find.text(errorEmptyeEmail), findsNothing);
        expect(find.text(errorEmptyPassword), findsNothing);
        await tester.tap(signInBtn);
        await tester.pump();
        expect(find.text(errorEmptyeEmail), findsOneWidget);
        expect(find.text(errorEmptyPassword), findsOneWidget);
      });
      testWidgets(
          'When entering correct email & password on text field and should trigger function call login function.',
          (WidgetTester tester) async {
        listenStub();
        when(
          () => mockAuthenticationCubit.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        await pumpWidget(tester);
        await tester.pump();
        final Finder textFields = find.byType(TextFormField);
        final Finder emailTextField = textFields.first;
        final Finder passwordTextField = textFields.last;
        expect(textFields, findsNWidgets(2));
        await tester.enterText(emailTextField, 'johndoe@gmail.com');
        await tester.enterText(passwordTextField, 'xxxxx');
        await tester.pump();
        final Finder signInBtn = find.ancestor(
          of: find.text('Sign In'),
          matching: find.byType(ElevatedButton),
        );
        expect(signInBtn, findsOneWidget);
        expect(find.text(errorEmptyeEmail), findsNothing);
        expect(find.text(errorEmptyPassword), findsNothing);
        await tester.tap(signInBtn);
        await tester.pump();
        verify(
          () => mockAuthenticationCubit.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
        // expect(find.byType(LoadingIndicator), findsOneWidget);
      });
      testWidgets(
          'When when toggling on the eye icon. The eye icon should be highlighted and unhighlighted',
          (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();
        final Finder textFields = find.byType(TextFormField);
        final Finder findPasswordField = textFields.last;
        const int defaultColor = 4288585374;
        const int highlightedColor = 4280391411;
        final Finder eyeIconGuesture = find.descendant(
          of: findPasswordField,
          matching: find.byType(GestureDetector),
        );
        Icon eyeIcon = tester.widget(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(Icon),
          ),
        );

        expect(eyeIcon.color?.value, defaultColor);
        await tester.tap(eyeIconGuesture);
        await tester.pumpAndSettle();
        eyeIcon = tester.widget(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(Icon),
          ),
        );
        expect(eyeIcon.color?.value, highlightedColor);
        await tester.tap(eyeIconGuesture);
        await tester.pumpAndSettle();
        eyeIcon = tester.widget(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(Icon),
          ),
        );
        expect(eyeIcon.color?.value, defaultColor);
      });
      testWidgets(
          'When when toggling on the eye icon. The password should toggle to obscured and not obscured',
          (WidgetTester tester) async {
        listenStub();
        await pumpWidget(tester);
        await tester.pump();
        final Finder textFields = find.byType(TextFormField);
        final Finder findPasswordField = textFields.last;
        EditableText passwordField = tester.widget<EditableText>(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(EditableText),
          ),
        );
        // final TextFormField txtf = tester.widget(findPasswordField);
        final Finder eyeIconGuesture = find.descendant(
          of: findPasswordField,
          matching: find.byType(GestureDetector),
        );

        await tester.enterText(findPasswordField, 'xxxxx');
        await tester.pump();
        // print(passwordField);
        expect(passwordField.obscureText, true);
        await tester.tap(eyeIconGuesture);
        await tester.pumpAndSettle();
        passwordField = tester.widget<EditableText>(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(EditableText),
          ),
        );
        expect(passwordField.obscureText, false);
        await tester.tap(eyeIconGuesture);
        await tester.pumpAndSettle();
        passwordField = tester.widget<EditableText>(
          find.descendant(
            of: findPasswordField,
            matching: find.byType(EditableText),
          ),
        );
        expect(passwordField.obscureText, true);
      });
      testWidgets('When Password is Incorrect. it should display snackbar.',
          (WidgetTester tester) async {
        when(() => mockAuthenticationCubit.state)
            .thenReturn(const AuthenticationState());
        const String errorCode = '101';
        const String message = 'Invalid username/password.';
        whenListen(
          mockAuthenticationCubit,
          Stream<AuthenticationState>.fromIterable(
            <AuthenticationState>[
              const LoginFailed(
                errorCode: errorCode,
                message: message,
              ),
            ],
          ),
        );
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.ancestor(
              of: find.text(message), matching: find.byType(SnackBar),),
          findsOneWidget,
        );
      });
      testWidgets('When state is loading. it should display loading indicator.',
          (WidgetTester tester) async {
        when(() => mockAuthenticationCubit.state)
            .thenReturn(const AuthenticationState());

        whenListen(
          mockAuthenticationCubit,
          Stream<AuthenticationState>.fromIterable(
            <AuthenticationState>[
              const LoginLoading(),
            ],
          ),
        );
        await pumpWidget(tester);
        await tester.pump();
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });
      testWidgets(
          'When state is login success. it should navigate to another screen.',
          (WidgetTester tester) async {
        when(() => mockAuthenticationCubit.state)
            .thenReturn(const AuthenticationState());

        whenListen(
          mockAuthenticationCubit,
          Stream<AuthenticationState>.fromIterable(
            <AuthenticationState>[
              const LoginSuccess(),
            ],
          ),
        );
        await pumpWidget(tester);
        await tester.pumpAndSettle();
        await tester.pump();
        expect(find.byType(LoginScreen), findsNothing);
        expect(find.byType(ControllerScreen), findsOneWidget);
      });
    });
  });
}
