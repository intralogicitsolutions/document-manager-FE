import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:document_manager/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../global/tokenStorage.dart';
import '../theme/theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _profilePicPath = '';

  Future<void> _pickProfilePic() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicPath =
            pickedFile.path; // Store the path of the selected image
      });
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Save the file locally
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/$fileName');
      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<void> _saveChanges() async {
    final url = Uri.parse(Global.BASE_URL + 'api/edit-user');

    try {
      String? token = await TokenStorage.getToken();
      var request = http.MultipartRequest('PATCH', url);

      request.headers['token'] = '$token';

      request.fields['first_name'] = _firstNameController.text.trim();
      request.fields['last_name'] = _lastNameController.text.trim();
      request.fields['email_id'] = _emailController.text.trim();

      if (_profilePicPath.isNotEmpty) {
        if (_profilePicPath.startsWith('http')) {
          // It's a URL, download the file first
          final File downloadedFile = await _downloadFile(
            _profilePicPath,
            'profile_pic.jpg',
          );
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            downloadedFile.path,
          ));
        } else {
          // It's a local file path
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            _profilePicPath,
          ));
        }
      }
      //
      // if (_profilePicPath.isNotEmpty) {
      //   var profilePic = await http.MultipartFile.fromPath(
      //     'files',
      //     _profilePicPath,
      //   );
      //   request.files.add(profilePic);
      // }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);
        print('response data ==> ${responseData.body}');

        if (jsonResponse['success'] == 1) {
          Global.userFirstName = jsonResponse['body']['first_name'];
          Global.userLastName = jsonResponse['body']['last_name'];
          Global.userEmail = jsonResponse['body']['email_id'];
          Global.userImagePath = jsonResponse['body']['image_path'];

          print('User updated successfully');
          print('Response: ${jsonResponse['body']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } else if (response.statusCode == 403) {
          print('Error: ${jsonResponse['msg']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to update profile: ${jsonResponse['msg']}')),
          );
        }
      } else {
        print('HTTP Error: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.text = Global.userFirstName!;
    _lastNameController.text = Global.userLastName!;
    _emailController.text = Global.userEmail!;
    if (Global.userImagePath != null) {
      _profilePicPath = Global.userImagePath!;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themer.gradient1,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Profile', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profilePicPath.isNotEmpty
                          ? (_profilePicPath.startsWith('http')
                                  ? NetworkImage(_profilePicPath)
                                  : FileImage(File(_profilePicPath)))
                              as ImageProvider
                          : null,
                      child: _profilePicPath.isEmpty
                          ? ClipOval(
                              child: Image.asset(
                                'assets/images/profile.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black12,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: _pickProfilePic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // First Name Field
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Last Name Field
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Edit Button
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
