import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.usernameOrEmail = ''});

  final String usernameOrEmail;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _otpLength = 4;
  final _otpControllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  bool _isEnabled = false;

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 4-digit verification code.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP verification is not connected yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Verification',
          style: GoogleFonts.poppins(
            color: const Color(0xff252525),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: _isEnabled, 
            onChanged: (value) => setState(() => _isEnabled = value),
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.17),
                      Center(
                        child: Text(
                          'Add OTP here',
                          style: GoogleFonts.poppins(
                            color: const Color(0xff252525),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 96),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_otpLength, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == _otpLength - 1 ? 0 : 20,
                            ),
                            child: SizedBox(
                              width: 52,
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff252525),
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      index < _otpLength - 1) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  } else if (value.isNotEmpty &&
                                      index == _otpLength - 1) {
                                    _focusNodes[index].unfocus();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Resend in 27:00',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 108,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _verify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff252525),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                'Verify',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      Center(
                        child: Text(
                          'OTP has been sent to registered email id',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xff79797B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
