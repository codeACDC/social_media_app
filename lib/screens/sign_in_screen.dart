import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/app_cubit.dart';
import 'package:social_media_app/screens/media_posts.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const id = 'sign_in_screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _userEmail = '';

  String _userPassword = '';

  final _formKey = GlobalKey<FormState>();

  late final FocusNode _userPasswordFocus;

  @override
  void initState() {
    super.initState();
    _userPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _userPasswordFocus.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    context.read<MediaAppCubit>().signIn(
          userEmail: _userEmail,
          password: _userPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MediaAppCubit, MediaAppState>(
        listener: (prevState, currState) {
          if (currState is SignedInLoaded) {
            // Navigator.of(context).pushReplacementNamed(MediaPosts.id);
          }
          else if (currState is SignedFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(currState.errorMessage),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SignedLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Sign in to social media app',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextFormField(
                        maxLength: 20,
                        textInputAction: TextInputAction.next,
                        onSaved: (email) => _userEmail = email!.trim(),
                        decoration: const InputDecoration(
                          labelText: 'E-Mail',
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        validator: (email) {
                          if (email!.isEmpty) {
                            return 'Please enter E-Mail!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_userPasswordFocus);
                        },
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextFormField(
                        maxLength: 20,
                        obscureText: true,
                        onSaved: (password) => _userPassword = password!.trim(),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                        focusNode: _userPasswordFocus,
                        textInputAction: TextInputAction.next,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Please enter password!';
                          }
                          if (password.length < 8) {
                            return 'Please enter longer password!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text(
                          'Sign In',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.id);
                        },
                        child: const Text('Sign up instead'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
