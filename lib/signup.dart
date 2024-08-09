import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final IconData? picon;
  final TextEditingController? formcontroller;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    required this.labelText,
    this.isPassword = false,
    this.picon,
    this.validator,
    this.formcontroller,
    super.key,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.formcontroller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        prefix: widget.picon != null ? Icon(widget.picon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: _toggleObscureText,
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
      validator: widget.validator,
      textAlign: TextAlign.center,
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@myseneca\.ca$').hasMatch(value)) {
      return 'email should end with @myseneca.ca';
    }
    return null;
  }

  /// Ensure Password is at least 8 characters long and max of 16

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8 || value.length > 16) {
      return 'Password length should be between 8 and 16';
    }
    return null;
  }

  Future<String> _postData() async {
    var url = Uri.parse('https://seneca-rate-my-professor.vercel.app/signup');
    String responseString = 'Error';
    try {
      var response = await http.post(
        url,
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      var resBody = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          resBody['email'] == _emailController.text) {
        debugPrint('User Created!');
        responseString = 'User Created!';
      } else if (resBody["errorResponse"]["code"] == 11000) {
        debugPrint('Repeated Email!');
        responseString = 'Repeated Email!';
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return responseString;
  }

  // create textcontroller for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size cs = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
          height: cs.height,
          width: cs.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: cs.width / 2,
                    height: cs.height / 20,
                    child: const RiveAnimation.asset('assets/goldstar.riv'),
                  )
                ],
              ),
              Text(
                "Rate My Professor",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: cs.height / 35,
                  // color: Colors.yellow[800],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: cs.height / 20,
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: cs.height / 40,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: cs.width / 8,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: 'Email',
                        picon: Icons.email,
                        formcontroller: _emailController,
                        validator: _validateEmail,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: CustomTextFormField(
                          labelText: 'Password',
                          isPassword: true,
                          formcontroller: _passwordController,
                          validator: _validatePassword,
                          picon: Icons.lock,
                        ),
                      ),
                      SizedBox(
                        width: cs.width,
                        height: cs.height / 15,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: cs.height / 6,
                                      width: cs.width / 2,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CircularProgressIndicator(),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: cs.height / 50,
                                              ),
                                              child: const Text(
                                                  'Creating User...'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              _postData().then((value) {
                                Navigator.pop(context);
                                if (value == 'User Created!') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: cs.height / 6,
                                          width: cs.width / 2,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: cs.height / 20,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: cs.height / 50,
                                                  ),
                                                  child: const Text(
                                                    'Account Created!\n Please click the activation link sent to your email',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (value == 'Repeated Email!') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: cs.height / 6,
                                          width: cs.width / 2,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.red,
                                                  size: cs.height / 20,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: cs.height / 50,
                                                  ),
                                                  child: const Text(
                                                    'An account with this email already exists!',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error!'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
