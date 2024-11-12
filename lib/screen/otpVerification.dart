import 'dart:convert';

import 'package:flutter/material.dart';
import '../global/global.dart';
import '../theme/theme.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class OtpVerification extends StatefulWidget {
  final String? email;
  const OtpVerification({super.key, this.email});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final String resetPasswordUrl = Global.BASE_URL + 'auth/resetPassword';

  Future<void> handleResetPassword() async {
    // Validate that the new password and confirm password match
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in both password fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      // Show error if passwords don't match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Proceed with the API call if the validation passes
    try {
      final response = await http.post(
        Uri.parse(resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_id': widget.email,
          'otp': _otpController.text,
          'new_password': _newPasswordController.text
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Show success dialog or navigate to a new screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Password reset successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color(0xFFF67DBC), // Pinkish color
              // Color(0xFFFFC2A2), // Light orange color
              Themer.gradient1,
              Themer.gradient2
            ],
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
                  // Icon or Avatar at the top
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.lock_open,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Page Title
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Instruction Text
                  Text(
                    'Enter the OTP sent to your email and set a new password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 30),

                  // OTP Field
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Themer.textColor.withOpacity(0.8)),
                      hintText: 'OTP',
                      hintStyle: TextStyle(color: Themer.textColor.withOpacity(0.8)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Themer.textColor),
                  ),
                  const SizedBox(height: 10),

                  // New Password Field
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, color: Themer.textColor.withOpacity(0.8)),
                      hintText: 'New Password',
                      hintStyle: TextStyle(color: Themer.textColor.withOpacity(0.8)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Themer.textColor),
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password Field
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, color: Themer.textColor.withOpacity(0.8)),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Themer.textColor.withOpacity(0.8)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Themer.textColor),
                  ),
                  const SizedBox(height: 20),

                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: handleResetPassword,
                      child: Text(
                        'Reset Password',
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

                  // Back to Login link
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Return to the previous page
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: Themer.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
//
// import '../global/global.dart';
// import '../theme/theme.dart';
// import 'login.dart';
//
// class OtpVerification extends StatefulWidget {
//   final String? email;
//
//   const OtpVerification({super.key, this.email});
//
//   @override
//   State<OtpVerification> createState() => _OtpVerificationState();
// }
//
// class _OtpVerificationState extends State<OtpVerification> {
//   final _otpController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final String resetPasswordUrl = Global.BASE_URL + 'auth/resetPassword';
//
//   Future<void> handleResetPassword() async {
//     // Validate that the new password and confirm password match
//     if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('Please fill in both password fields.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     if (_newPasswordController.text != _confirmPasswordController.text) {
//       // Show error if passwords don't match
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('Passwords do not match. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     // Proceed with the API call if the validation passes
//     try {
//       final response = await http.post(
//         Uri.parse(resetPasswordUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email_id': widget.email,
//           'otp': _otpController.text,
//           'new_password': _newPasswordController.text
//         }),
//       );
//
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         // Show success dialog or navigate to a new screen
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Success'),
//             content: const Text('Password reset successfully'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Login()),
//                   );
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       } else {
//         // Handle error
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Error'),
//             content: Text(responseData['message']),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle network or other errors
//       print('Error during password reset: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Reset Password'.toUpperCase(),
//           style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: SvgPicture.asset(
//             "assets/images/ios-back-arrow.svg",
//             colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 0.0,
//         toolbarHeight: 60.2,
//         toolbarOpacity: 0.8,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(25),
//             bottomLeft: Radius.circular(25),
//           ),
//         ),
//         backgroundColor: Themer.buttonColor,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _otpController,
//                 decoration: InputDecoration(
//                   labelText: 'OTP',
//                   prefixIcon: const Icon(Icons.lock),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _newPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   prefixIcon: Icon(Icons.password),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//                 obscureText: true, // Add this to hide the password
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   prefixIcon: const Icon(Icons.password),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//                 obscureText: true, // Add this to hide the password
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: handleResetPassword,
//                   child: Text(
//                     'Submit',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Themer.buttonColor,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
