import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/repositories/user_repository.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";

/// Splash screen for the app.
///
/// It loads the user and redirects to the login screen if the user is not logged in or to the main screen if the user is logged in.
class SplashScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/splash-screen";

  /// Creates a new splash screen
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _tryLogin(ref.read(userRepositoryProvider)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                });
              } else {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                });
              }
            }
            return SizedBox(
              width: 200,
              child: Image.asset("assets/images/logo.png"),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _tryLogin(UserRepository userRepository) async {
    return await userRepository.getToken() != null;
  }
}
