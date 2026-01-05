import 'package:chat_with_gemini/features/home/presentation/manager/home_view_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/styles.dart';

class InitialBody extends StatefulWidget {
  const InitialBody({super.key});

  @override
  State<InitialBody> createState() => _InitialBodyState();
}

class _InitialBodyState extends State<InitialBody> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: kBackgroundColor
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    kLogo,
                    height: 80,
                    width: 200,
                  ),
                ),
                TextFormField(
                    controller: textController,
                    style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                            onPressed: (){
                              String message = textController.text;
                              if (message.isNotEmpty) {
                                BlocProvider.of<HomeCubit>(context).sendMessage(message);
                              }
                            },
                            icon: Icon(Icons.send_rounded, color: Colors.white,)
                        ),
                        label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Talk to Gemini',
                              style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),))
                    )
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
