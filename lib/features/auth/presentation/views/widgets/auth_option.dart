import 'package:chat_with_gemini/core/utils/styles.dart';
import 'package:flutter/material.dart';

class AuthOption extends StatelessWidget {
  const AuthOption({super.key, required this.labelIcon, required this.title, required this.function});

  final IconData labelIcon;
  final String title;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
        onPressed: function,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(labelIcon,color: Colors.black,size: 24,),
                      SizedBox(width: 10,),
                      Text(
                      title,
                      style: Styles.fontStyle26.copyWith(color: Colors.black,fontSize: 22),
                    ),
                  ],
                ),
            )
    );
  }
}