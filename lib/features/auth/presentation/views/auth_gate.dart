// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:chat_with_gemini/core/utils/styles.dart';
import 'package:chat_with_gemini/features/auth/data/auth_service.dart';
import 'package:chat_with_gemini/features/auth/presentation/views/widgets/auth_option.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants.dart';
import '../../../../core/utils/app_router.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height * 0.3;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: kBackgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign In",
                  style: Styles.fontStyle26.copyWith(fontSize: 40),
                ),
              ),
              SizedBox(height: 25,),
              AuthOption(
                title: 'Email Address',
                labelIcon: Icons.email,
                function: (){
                  GoRouter.of(context).push(AppRouter.kLoginView);
                },
              ),
              SizedBox(height: 15,),
              AuthOption(
                title: 'Google',
                labelIcon: FontAwesomeIcons.google,
                function: () async {
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signing in with Google...'),duration: Duration(seconds: 1,),
                    ));

                    final user = await AuthService().signInWithGoogle();

                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign-in successful!'),duration:Duration(seconds: 1,)),
                      );
                      GoRouter.of(context).push(AppRouter.kHomeView);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google sign-in was canceled.'),duration:Duration(seconds: 1,)),
                      );
                    }
                  } catch (e) {
                    debugPrint('Google Sign-In Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign-in failed: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        duration:Duration(seconds: 1,)
                      ),
                    );
                  }
                },
              ),


              SizedBox(height: height,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Styles.fontStyle26.copyWith(fontSize: 14),
                  ),
                  SizedBox(width: 3,),
                  TextButton(
                      onPressed:(){
                        GoRouter.of(context).push(AppRouter.kHomeView);
                      },
                      child: Text(
                        "Register Now!",
                        style: Styles.fontStyle26.copyWith(fontSize: 14,color: kSecondaryColor),
                      ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
