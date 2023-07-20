import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
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
    final user = ref.watch(userServiceProvider);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: user.when(
            data: (value) {
              if (value == null) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                });
              } else {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                });
              }
              return SizedBox(child: Image.asset("assets/images/logo.png"));
            },
            error: (error, stack) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
              });
              return SizedBox(child: Image.asset("assets/images/logo.png"));
            },
            loading: () => SizedBox(child: Image.asset("assets/images/logo.png")),
          ),
        ),
      ),
    );
  }
}
