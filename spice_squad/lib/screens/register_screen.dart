import 'package:flutter/material.dart';
import 'package:spice_squad/screens/group_joining_screen.dart';
import 'package:spice_squad/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

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
                'Registrieren',
                style: Theme.of(context).textTheme.headline4,
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
                        validator: _validateUserName,
                        keyboardType: TextInputType.name,
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          hintText: 'Nutzername',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        validator: _validatePassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Passwort',
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
                        controller: _passwordRepeatController,
                        decoration: const InputDecoration(
                          hintText: 'Passwort wiederholen',
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
                  'Du hast bereits ein Konto?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  width: 4,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                  child: const Text('Anmelden'),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) _register(context);
                  },
                  child: const Text('Weiter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          GroupJoiningScreen.routeName, (route) => false);
    }
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

  String? _validateUserName(String? userName) {
    if (userName == null || userName.isEmpty) {
      return 'Bitte gib einen Nutzernamen ein';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Bitte gib ein Passwort ein';
    }
    if (password.length < 8) {
      return 'Das Passwort muss mindestens 8 Zeichen lang sein';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Das Passwort muss mindestens einen Großbuchstaben enthalten';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Das Passwort muss mindestens einen Kleinbuchstaben enthalten';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Das Passwort muss mindestens eine Zahl enthalten';
    }
    if (password != _passwordRepeatController.text) {
      return 'Die Passwörter stimmen nicht überein';
    }
    return null;
  }
}