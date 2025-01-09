
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


        print('image path is ===> ${Global.userImagePath}');

        final token = user['token'];
        await TokenStorage.saveToken(token);
        Global.token = token;
        print('token :: $token');
        print('userId :: ${Global.userId}');
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

