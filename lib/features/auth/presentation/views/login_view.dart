import 'package:chat_with_gemini/core/utils/styles.dart';
import 'package:chat_with_gemini/features/auth/data/auth_service.dart';
import 'package:chat_with_gemini/features/auth/presentation/views/widgets/custom_button.dart';
import 'package:chat_with_gemini/features/auth/presentation/views/widgets/custom_text_form_filed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../constants.dart';
import '../../../../core/utils/app_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              gradient: kBackgroundColor
            ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome to ',
                        style: Styles.fontStyle26,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: AssetImage(kLogo),
                        height: 80,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 40,),
                    CustomTextFormFiled(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(Icons.email, color: Colors.white,),
                      ),
                      textEditingController: emailController,
                      label: "Email Address",
                    ),
                    SizedBox(height: 14,),
                    CustomTextFormFiled(
                      obscureText: obscureText, // Use the state value here
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                            color: Colors.white,
                          )),
                      textEditingController: passwordController,
                      label: "Password",
                    ),
                    SizedBox(height: 20,),
                    CustomButton(
                      child: Text(
                        'Login',
                        style: Styles.fontStyle26.copyWith(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          bool isAuthenticated = await AuthService().signInWithEmail(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          if (isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login successful"),duration:Duration(seconds: 1,)
                              ),
                            );
                            GoRouter.of(context).push(AppRouter.kHomeView);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Invalid email or password"),duration:Duration(seconds: 1,)),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login failed: ${e.toString()}"),duration:Duration(seconds: 1,)),
                          );
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },

                    ),

                    SizedBox(height: 20,),
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
                            GoRouter.of(context).push(AppRouter.kRegisterView);
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
          ),
        ),
      ),
    );
  }
}
