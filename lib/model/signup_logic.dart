import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ratemyprofessor/page/otp.dart';

abstract class SignUpBase extends StatefulWidget {
  const SignUpBase({super.key});
}

abstract class SignUpBaseState<T extends SignUpBase> extends State<T> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@myseneca\.ca$').hasMatch(value)) {
      return 'Please enter a valid Seneca Email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8 || value.length > 16) {
      return 'Password length should be between 8 and 16';
    }
    return null;
  }

  Future<String> postData() async {
    var url = Uri.parse('https://rmp-roan.vercel.app/register');
    try {
      var response = await http.post(
        url,
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200 &&
          response.body == 'Registration Successful') {
        return 'User Created!';
      } else if (response.body == "Email already exists" &&
          response.statusCode == 400) {
        return 'Repeated Email!';
      }
      return 'Error';
    } catch (e) {
      debugPrint('Error: $e');
      return 'Error';
    }
  }

  Future<void> handleSignUp() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 50,
                      ),
                      child: const Text('Creating User...'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      final result = await postData();

      if (mounted) {
        Navigator.pop(context);
        _showResultDialog(result);
      }
    }
  }

  void _showResultDialog(String result) {
    IconData icon;
    Color color;
    String message;

    switch (result) {
      case 'User Created!':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        message =
            'Account Created!\n Please check for the otp code sent to your email';
        break;
      case 'Repeated Email!':
        icon = Icons.cancel_rounded;
        color = Colors.red;
        message = 'An account with this email already exists!';
        break;
      default:
        icon = Icons.warning;
        color = Colors.amber;
        message =
            'Error! Try again, if the problem persists, send an email to collinscodes@gmail.com';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: MediaQuery.of(context).size.height / 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 50,
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (result == 'User Created!') {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OTPCHECKER(),
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
