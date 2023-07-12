import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";

class SplashScreen extends ConsumerWidget {
  static const routeName = "/splash-screen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userServiceProvider);
    return user.when(
        data: (value) {
          if (value == null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            });
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
            });
          }
          return SizedBox(child: Image.asset("assets/images/logo.png"));
        },
        error: (error, stack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          });
          return SizedBox(child: Image.asset("assets/images/logo.png"));
        },
        loading: () => SizedBox(child: Image.asset("assets/images/logo.png")));
  }
}
