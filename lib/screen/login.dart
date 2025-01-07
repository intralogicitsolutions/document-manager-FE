// import 'dart:convert';
// import 'dart:io'; // Import for File
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart'; // Import image_picker
// import 'package:http/http.dart' as http;
// import '../global/global.dart';
// import '../global/tokenStorage.dart';
// import '../theme/theme.dart';
// import 'dashboard.dart';
// import 'forgotPassword.dart';
//
// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   bool isLogin = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Positioned(
//           //   top: -80,
//           //   left: -80,
//           //   child: CircleAvatar(
//           //     radius: 150,
//           //     backgroundColor: Colors.purple.shade200,
//           //   ),
//           // ),
//           // Positioned(
//           //   top: 60,
//           //   right: -80,
//           //   child: CircleAvatar(
//           //     radius: 100,
//           //     backgroundColor: Colors.purple.shade100,
//           //   ),
//           // ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 30),
//                     // Image.asset("assets/images/quiz_logo1.png", height: 130),
//                     // const SizedBox(height: 10),
//                     LoginForm(isLogin: isLogin),
//                     const SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: () {
//                         if (mounted) {
//                           setState(() {
//                             isLogin = !isLogin;
//                           });
//                         }
//                       },
//                       child: Text(
//                         isLogin
//                             ? "Don't have an account? Sign up"
//                             : "Already have an account? Login",
//                         style: const TextStyle(
//                           color: Themer.textColor,
//                           fontSize: 16,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class LoginForm extends StatefulWidget {
//   final bool isLogin;
//
//   const LoginForm({required this.isLogin});
//
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<LoginForm> {
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   File? _image;
//   String? _imageFilename;
//   bool isPasswordVisible = false;
//   bool isLoading = false;
//
//   final String signupUrl = Global.BASE_URL + 'auth/signup';
//   final String signinUrl = Global.BASE_URL + 'auth/signin';
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//
//     // Show a dialog to choose between camera and gallery
//     final pickedSource = await showDialog<ImageSource>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Image Source', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, ImageSource.camera),
//               child: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, ImageSource.gallery),
//               child: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (pickedSource != null) {
//       final XFile? image = await _picker.pickImage(source: pickedSource);
//
//       if (image != null) {
//         setState(() {
//           _image = File(image.path);
//         });
//       }
//     }
//   }
//   //String imgUrl = "https://quizz-app-backend-3ywc.onrender.com/images/upload";
//
//
//   Future<void> handleSignup() async {
//     try {
//       if (mounted) {
//         setState(() {
//           isLoading = true;
//         });
//       }
//
//       String? imgUrl;
//       if (_image != null) {
//         // Create a request to upload the image
//         var request = http.MultipartRequest(
//           'POST',
//           // Uri.parse('https://quizz-app-backend-3ywc.onrender.com/images/upload'),
//           Uri.parse(Global.BASE_URL + 'images/upload'),
//         );
//         request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//
//         // Send the request
//
//         var response = await request.send();
//         var responseData = await http.Response.fromStream(response);
//
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> imageResponse = jsonDecode(responseData.body);
//           imgUrl = imageResponse['data']['img_url']; // Get img_url from the response
//           _imageFilename = imageResponse['data']['filename'];
//           print('image response :::::::: ${imgUrl} , ${_imageFilename} , ${imageResponse}');
//         } else {
//           // Handle image upload error
//           print('Image upload failed: ${responseData.body}');
//           return; // Stop the signup process if image upload fails
//         }
//       }
//
//       var requestBody = {
//         'first_name': _firstNameController.text.trim(),
//         'last_name': _lastNameController.text.trim(),
//         'email_id': _emailController.text.trim(),
//         'password': _passwordController.text.trim(),
//         'image_path': imgUrl ?? '',
//       };
//
//       // Send the request as JSON
//       final response = await http.post(
//         Uri.parse(signupUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       // Handle the response
//       final Map<String, dynamic> responseJson = jsonDecode(response.body);
//
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//
//         await handleSignin(_emailController.text, _passwordController.text);
//         print('Signup failed with status ${response.statusCode}: ${response.body}');
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const DashboardScreen()),
//         );
//       } else if (response.statusCode == 400) {
//         if (!mounted) return;
//         print('Signup failed with status ${response.statusCode}: ${response.body}');
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Signup Error'),
//             content: Text(responseJson['message']),
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
//       print('Error during signup: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false; // Hide loading indicator
//         });
//       }
//     }
//   }
//
//   Future<void> handleSignin(String email, String password) async {
//     try {
//       setState(() {
//         isLoading = true; // Show loading indicator
//       });
//
//       final response = await http.post(
//         Uri.parse(signinUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email_id': email,
//           'password': password,
//         }),
//       );
//
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       if (!mounted) return;
//
//       if (response.statusCode == 200) {
//         final userId = responseData['data']['_id'];
//         Global.userId = userId;
//         final userFirstName = responseData['data']['first_name'];
//         Global.userFirstName = userFirstName;
//
//         final userLastName = responseData['data']['last_name'];
//         Global.userLastName = userLastName;
//
//         final userEmail = responseData['data']['email_id'];
//         Global.userEmail = userEmail;
//
//         final userImagePath = responseData['data']['image_path'];
//         Global.userImagePath = userImagePath;
//
//         print('image path is ===> ${Global.userImagePath}');
//
//         final token = responseData['data']['access_token'];
//         await TokenStorage.saveToken(token);
//         Global.token = token;
//         print('token :: $token');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const DashboardScreen()),
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Login Error'),
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
//       print('Error during signin: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             if (!widget.isLogin) const SizedBox(height: 10),
//             if (!widget.isLogin)
//               GestureDetector(
//                 onTap: pickImage,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: _image == null
//                       ? (_imageFilename == null
//                       ? Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.person, color: Colors.grey, size: 40),
//                   )
//                       : Image.network(
//                     Global.BASE_URL + 'images/uploads/$_imageFilename',
//                     width: 80,
//                     height: 80,
//                     fit: BoxFit.cover,
//                   ))
//                       : ClipOval(
//                     child: Image.file(
//                       _image!,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//
//             if (!widget.isLogin)
//               TextField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(
//                   labelText: 'First name',
//                   prefixIcon: const Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//               ),
//             if (!widget.isLogin) const SizedBox(height: 10),
//             if (!widget.isLogin)
//               TextField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Last name',
//                   prefixIcon: const Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//               ),
//             if (!widget.isLogin) const SizedBox(height: 10),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: const Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _passwordController,
//               obscureText: !isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 prefixIcon: IconButton(
//                   icon: Icon(
//                     isPasswordVisible ? Icons.lock_open : Icons.lock,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isPasswordVisible = !isPasswordVisible;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//               ),
//             ),
//             if (widget.isLogin)
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ForgotPassword()),
//                     );
//                   },
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       color: Themer.textColor,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ),
//
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (widget.isLogin) {
//                     handleSignin(_emailController.text, _passwordController.text);
//                   } else {
//                     handleSignup();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Themer.selectColor,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   widget.isLogin ? 'Login' : 'Sign Up',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (isLoading)
//           const Center(
//             child: CircularProgressIndicator(),
//           ),
//       ],
//     );
//   }
// }
//



import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';
import 'dashboard.dart';
import 'forgotPassword.dart';
import 'homeScreen.dart';
import 'homeTabPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = true;
  File? image;
  String? imageFilename;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Show a dialog to choose between camera and gallery
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final XFile? pickedImage = await _picker.pickImage(source: pickedSource);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
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
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Container for Login/Signup form
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // Semi-transparent background
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white.withOpacity(0.4),width: 2.0)
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Space for CircleAvatar
                        if (!isLogin) const SizedBox(height: 40),
                        // Title Text
                        Text(
                          isLogin ? 'LOGIN' : 'SIGN UP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Login/Signup Form
                        LoginForm(isLogin: isLogin, image: image, imageFilename: imageFilename,),
                        const SizedBox(height: 20),

                        // Switch between Login and Sign Up
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: isLogin ? "Don't have an account? " : "Already have an account? ",
                                  style: const TextStyle(
                                    color: Colors.white, // White color for the first part
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: isLogin ? "Sign up" : "Login",
                                  style: const TextStyle(
                                    color: Themer.textColor, // Original color for "Sign up" or "Login"
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CircleAvatar for sign-up only
                  if (!isLogin)
                    Positioned(
                      top: 10,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black26,
                          child: image == null ?  (imageFilename == null
                            ?  Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ):Image.network(
                            Global.BASE_URL + 'images/uploads/$imageFilename',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ))
                              : ClipOval(
                            child: Image.file(
                              image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
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

class LoginForm extends StatefulWidget {
  final bool isLogin;
  final File? image;
  final String? imageFilename;

  LoginForm({required this.isLogin, this.image, this.imageFilename, });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // File? _image;
  // String? _imageFilename;
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? imageFilename;

  final String signupUrl = Global.BASE_URL+'api/signup';
  final String signinUrl = Global.BASE_URL+'api/signin';

  @override
  void initState() {
    super.initState();
    imageFilename = widget.imageFilename;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void updateImageFilename(String newFilename) {
    setState(() {
      imageFilename = newFilename;
    });
  }

  Future<void> handleSignup() async {

      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
     // final url = Uri.parse(Global.BASE_URL + 'api/signup');
      try{
        var request = http.MultipartRequest('POST', Uri.parse(signupUrl));
        request.fields['first_name'] = _firstNameController.text.trim();
        request.fields['last_name'] = _lastNameController.text.trim();
        request.fields['email_id'] = _emailController.text.trim();
        request.fields['password'] = _passwordController.text.trim();
        if (widget.image != null) {
          var fileStream = http.MultipartFile.fromBytes(
            'files',
            await widget.image!.readAsBytes(),
            filename: widget.image!
                .path
                .split('/')
                .last,
          );
          request.files.add(fileStream);
        }

        var response = await request.send();
        if(response.statusCode == 200){
          var responseData = await http.Response.fromStream(response);
          var jsonResponse = json.decode(responseData.body);
          await handleSignin(_emailController.text, _passwordController.text);
          Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeTabPage()),
                  );
          print('Signup failed with status ${response.statusCode}: ${responseData.body}');
          print('Response: ${jsonResponse['msg']}');
          print('User Details: ${jsonResponse['body']}');
        }else {
          print('Error: ${response.reasonPhrase}');
        }

      }catch(e){
        print('Exception occurred: $e');
      }
  }

  // Future<void> handleSignup1() async {
  //   try {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //
  //     }
  //
  //     String? imgUrl;
  //     if (widget.image != null) {
  //       // Create a request to upload the image
  //       var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(Global.BASE_URL + 'api/upload-document'),
  //       );
  //       request.fields['first_name'] = _firstNameController.text.trim();
  //       request.fields['last_name'] = _lastNameController.text.trim();
  //       request.fields['email_id'] = _emailController.text.trim();
  //       request.fields['password'] = _passwordController.text.trim();
  //
  //       var fileStream = http.MultipartFile.fromBytes(
  //         'files', // Key for the file field
  //         await widget.image!.readAsBytes(),
  //         filename: widget.image!.path.split('/').last,
  //       );
  //       request.files.add(fileStream);
  //
  //      // request.files.add(await http.MultipartFile.fromPath('files', widget.image!.path));
  //
  //       var response = await request.send();
  //       var responseData = await http.Response.fromStream(response);
  //
  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> imageResponse = jsonDecode(responseData.body);
  //         final imagedata = imageResponse['body'][0];
  //         imgUrl = imagedata['document_url']; // Get img_url from the response
  //         imageFilename = imagedata['originalName'];
  //         // updateImageFilename(imageResponse['data']['filename']);
  //         print('image response :::::::: ${imgUrl} , ${widget.imageFilename} , ${imageResponse}');
  //       } else {
  //         // Handle image upload error
  //         print('Image upload failed: ${responseData.body}');
  //         return; // Stop the signup process if image upload fails
  //       }
  //     }
  //
  //     var requestBody = {
  //       'first_name': _firstNameController.text.trim(),
  //       'last_name': _lastNameController.text.trim(),
  //       'email_id': _emailController.text.trim(),
  //       'password': _passwordController.text.trim(),
  //       'image_path': imgUrl ?? '',
  //     };
  //
  //     // Send the request as JSON
  //     final response = await http.post(
  //       Uri.parse(signupUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     // Handle the response
  //     final Map<String, dynamic> responseJson = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       if (!mounted) return;
  //
  //       await handleSignin(_emailController.text, _passwordController.text);
  //       print('Signup failed with status ${response.statusCode}: ${response.body}');
  //
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomeTabPage()),
  //       );
  //     } else if (response.statusCode == 400) {
  //       if (!mounted) return;
  //       print('Signup failed with status ${response.statusCode}: ${response.body}');
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Signup Error'),
  //           content: Text(responseJson['message']),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error during signup: $e');
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false; // Hide loading indicator
  //       });
  //     }
  //   }
  // }

  Future<void> handleSignin(String email, String password) async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      final response = await http.post(
        Uri.parse(signinUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_id': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200 && responseData['success'] == 1) {
        final user = responseData['body'][0];

        Global.userId = user['_id'];
        Global.userFirstName = user['first_name'];
        Global.userLastName = user['last_name'];
        Global.userEmail = user['email_id'];
        Global.userImagePath = user['image_path'];

        // final userId = responseData['data']['_id'];
        // Global.userId = userId;
        // final userFirstName = responseData['data']['first_name'];
        // Global.userFirstName = userFirstName;
        //
        // final userLastName = responseData['data']['last_name'];
        // Global.userLastName = userLastName;
        //
        // final userEmail = responseData['data']['email_id'];
        // Global.userEmail = userEmail;
        //
        // final userImagePath = responseData['data']['image_path'];
        // Global.userImagePath = userImagePath;

        print('image path is ===> ${Global.userImagePath}');

        final token = user['token'];
        await TokenStorage.saveToken(token);
        Global.token = token;
        print('token :: $token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeTabPage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(responseData['msg']),
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
      print('Error during signin: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (!widget.isLogin)
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  prefixIcon:  Icon(Icons.person, color: Themer.textColor.withOpacity(0.8)),
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Themer.textColor.withOpacity(0.8)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  border: const OutlineInputBorder(
                    //borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                style: const TextStyle(color: Themer.textColor),
              ),
            if (!widget.isLogin) const SizedBox(height: 15),
            if (!widget.isLogin)
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  prefixIcon:  Icon(Icons.person, color: Themer.textColor.withOpacity(0.8)),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Themer.textColor.withOpacity(0.8)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5
                  ),
                  border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                style: const TextStyle(color: Themer.textColor),
              ),
            if (!widget.isLogin) const SizedBox(height: 15),

            //if (!isLogin)
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Themer.textColor.withOpacity(0.8)),
                hintText: 'Email',
                hintStyle:  TextStyle(color: Themer.textColor.withOpacity(0.8)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                border: const OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              style:  const TextStyle(color: Themer.textColor),
            ),
            const SizedBox(height: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.lock, color: Themer.textColor.withOpacity(0.8)),
                    hintText: 'Password',
                    hintStyle:  TextStyle(color: Themer.textColor.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: const OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Themer.textColor),
                ),
                if (widget.isLogin) const SizedBox(height: 10.0),
                if (widget.isLogin)// Space between TextField and "Forgot Password?" text
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const ForgotPasswordPage()),
                      );
                    },
                    child: const Padding(
                      padding:  EdgeInsets.only(left: 8.0),
                      child:  Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Themer.textColor, // Match color to your theme
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500
                          //decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.isLogin) {
                    handleSignin(_emailController.text, _passwordController.text);
                  } else {
                    handleSignup();
                  }
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomeTabPage()),
                  // );
                },
                child: Text(
                  widget.isLogin ? 'LOGIN' : 'SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
          ],
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

