import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPCHECKER extends StatefulWidget {
  const OTPCHECKER({super.key});

  @override
  State<OTPCHECKER> createState() => _OTPCHECKERState();
}

class _OTPCHECKERState extends State<OTPCHECKER> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget otpField({required int index, bool? main}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: TextFormField(
          focusNode: _focusNodes[index],
          controller: _controllers[index],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          autofocus: main ?? false,
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < _focusNodes.length - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                _focusNodes[index].unfocus();
              }
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          onEditingComplete: () {
            if (_controllers[index].text.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    final String? username = await asyncPrefs.getString('username');
    final String? password = await asyncPrefs.getString('password');

    final String otp = _controllers.fold<String>(
      '',
      (previousValue, element) => previousValue + element.text,
    );

    debugPrint('username: $username, password: $password, otp: $otp');
  }

  @override
  Widget build(BuildContext context) {
    Size cs = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: cs.height,
          width: cs.width,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: cs.width * 0.07),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) {
                          return otpField(index: index, main: index == 0);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: cs.height / 20,
                      ),
                      child: SizedBox(
                        width: cs.width,
                        height: cs.height / 15,
                        child: ElevatedButton(
                          onPressed: _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Verify OTP'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
