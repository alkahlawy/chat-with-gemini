import 'package:chat_with_gemini/features/auth/presentation/views/login_view.dart';
import 'package:chat_with_gemini/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/auth_gate.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';

class AppRouter{
  static const kHomeView = '/homeView';
  static const kLoginView = '/loginView';
  static const kOnboardingView = '/onboardingView';
  static const kRegisterView = '/registerView';
  static const kProfileView = '/profileView';
  static const kAuthGate = '/authGate';

  final GoRouter appRouter = GoRouter(
    initialLocation: kAuthGate,
    routes: <RouteBase>[
      GoRoute(
        path: kAuthGate,
        builder: (context, state) => AuthGate(),
      ),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => RegisterView(),
      ),
      GoRoute(
        path: kProfileView,
        builder: (context, state) => ProfileView(),
      ),
    ],
  );
}