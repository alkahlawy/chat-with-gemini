import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/styles.dart';
import '../../../auth/data/auth_service.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff222222),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
        gradient: kBackgroundColor
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
        Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(style: BorderStyle.solid, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(FontAwesomeIcons.user, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Text(
                'Name: ${user!.displayName}',
                style: Styles.fontStyle26.copyWith(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ]
        ),
      ),
    ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(style: BorderStyle.solid, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(FontAwesomeIcons.user, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Email: ${user.email}',
                      style: Styles.fontStyle26.copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  ]
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(style: BorderStyle.solid, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 6, top: 20, bottom: 20),
              child: MaterialButton(
                  onPressed:() async {
                    try{
                      await AuthService().signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                        ),
                      );
                      GoRouter.of(context).pushReplacement(AppRouter.kAuthGate);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Something went wrong while logging out : $e '),
                        ),
                      );
                    }
                  },
                  child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(Icons.logout_outlined, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: Styles.fontStyle26.copyWith(fontSize: 20),
                        )
                      ]
                  ),
              ),
            ),
          )
        ]
        ),
      ),
    ),
      ),
    );
    }

}
