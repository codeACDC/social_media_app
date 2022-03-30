import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/app_cubit.dart';
import 'package:social_media_app/screens/media_chats.dart';
import 'package:social_media_app/screens/media_post_screen.dart';
import 'package:social_media_app/screens/media_posts.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry/sentry_io.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0c4ad0a852ad47d6a1ebd62dca879481@o1181471.ingest.sentry.io/6294861';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      try {
        runApp(const MyApp());
      } catch (exception, stackTrace) {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
      };
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MediaPosts();
          } else {
            return const SignInScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaAppCubit>(
      create: (context) => MediaAppCubit(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: _buildHomeScreen(),
        routes: {
          SignInScreen.id: (context) => const SignInScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          MediaPosts.id: (context) => const MediaPosts(),
          MediaPostScreen.id: (context) => const MediaPostScreen(),
          MediaChats.id: (context) => const MediaChats(),
        },
      ),
    );
  }
}
