import 'package:chat_with_gemini/constants.dart';

class OnboardingContent {
  final String title;
  final String image;
  final String desc;

  OnboardingContent({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: "Welcome to Chat With Gemini",
    image: kLogo,
    desc: "A cool friend to chat with!",
  ),
  OnboardingContent(
    title: "Chat With Gemini",
    image: kLogo,
    desc: "Will be ready to chat with & help you with your problems.",
  ),
];