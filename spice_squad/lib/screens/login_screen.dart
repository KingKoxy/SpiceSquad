import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/main_screen.dart';
import 'package:spice_squad/screens/password_reset_screen.dart';
import 'package:spice_squad/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 240,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'E-Mail',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Passwort',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Text(
                  'Du hast noch kein Konto?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  width: 4,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegisterScreen.routeName);
                  },
                  child: const Text('Registrieren'),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) _login(context);
                  },
                  child: const Text('Weiter'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(PasswordResetScreen.routeName);
                },
                child: const Text('Passwort vergessen?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) {
    //TODO: Implement login

    Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
  }

  String? _validateEmail(String? email) {
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (email == null || email.isEmpty) {
      return 'Bitte gib eine E-Mail-Adresse ein';
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return 'Bitte gib eine gültige E-Mail-Adresse ein';
    }
    return null;
  }
}
