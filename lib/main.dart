import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/get_single_other_user.dart/get_single_other_user_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/user_cubit.dart';
import 'package:graze_app/features/presentation/screens/auth/sign_in_page.dart';
import 'package:graze_app/features/presentation/screens/main_screen/main_screen.dart';
import 'package:graze_app/on_generate_route.dart';
import 'package:graze_app/features/presentation/cubit/auth/auth_cubit.dart';
import 'injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Graze App",
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return const SignInPage();

                } else {
                  return const SignInPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}


