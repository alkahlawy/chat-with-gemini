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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                        'Register to ',
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
                        'Register',
                        style: Styles.fontStyle26.copyWith(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          bool isRegistered = await AuthService().registerWithEmail(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          if (isRegistered) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration successful")),
                            );
                            GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration failed")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Registration failed: ${e.toString()}")),
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
                          "Have an account?",
                          style: Styles.fontStyle26.copyWith(fontSize: 14),
                        ),
                        SizedBox(width: 3,),
                        TextButton(
                          onPressed:(){
                            GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                          },
                          child: Text(
                            "Login Now!",
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
