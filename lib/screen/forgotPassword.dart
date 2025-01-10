import 'dart:convert';

import 'package:document_manager/screen/login.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';
import 'package:http/http.dart' as http;
import 'changePassword.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isLoading = false;
  final _emailController = TextEditingController();
  final String forgotPasswordUrl = Global.BASE_URL + 'api/forgot-password';

  Future<void> handleForgotPassword() async {
    setState(() {
      isLoading = true;
    });
    print('email : ${_emailController.text}');
    String email = _emailController.text.trim();
    try {
      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email_id': email}),
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('fprgot password response data ==> ${responseData}');

      setState(() {
        isLoading = false;
      });
      if (responseData['code'] == 200 && responseData['success'] == 1) {
        print('isLoading status ==> ${isLoading}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('${responseData["msg"]}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle error
        print(responseData['msg']);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(responseData['msg'] ?? 'An unknown error occurred.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print('Error during password reset: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Background gradient
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Themer.gradient1, Themer.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Optional icon or avatar at the top
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.lock_reset,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Instruction text
                      Text(
                        'Enter your email address and we will send you a password reset link.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Themer.textColor.withOpacity(0.8)),
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Themer.textColor.withOpacity(0.8)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Themer.textColor),
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: handleForgotPassword,
                          child: Text(
                            'Send Reset Link',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Themer.buttonColor.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Return to the previous page
                        },
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                              color: Themer.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                              // decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              //color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
