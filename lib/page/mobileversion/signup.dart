import 'package:flutter/material.dart';
import 'package:ratemyprofessor/model/signup_logic.dart';
import 'package:ratemyprofessor/model/signup_text_field_class.dart';
import 'package:rive/rive.dart';

class MobileSignup extends SignUpBase {
  const MobileSignup({super.key});

  @override
  State<MobileSignup> createState() => _MobileSignupState();
}

class _MobileSignupState extends SignUpBaseState<MobileSignup> {
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: cs.height / 20),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: cs.height / 40,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: cs.width / 8),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          labelText: 'Email',
                          picon: Icons.email,
                          formcontroller: emailController,
                          validator: validateEmail,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CustomTextFormField(
                            labelText: 'Password',
                            isPassword: true,
                            formcontroller: passwordController,
                            validator: validatePassword,
                            picon: Icons.lock,
                          ),
                        ),
                        SizedBox(
                          width: cs.width,
                          height: cs.height / 15,
                          child: ElevatedButton(
                            onPressed: handleSignUp,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
