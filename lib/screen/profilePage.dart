import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/theme.dart';



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _profilePicUrl = '';

  // Pick profile picture from gallery or camera
  Future<void> _pickProfilePic() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicUrl = pickedFile.path; // Store the path of the selected image
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-populate the fields with sample data (you can fetch this data from an API or database)
    _firstNameController.text = 'Ishita';
    _lastNameController.text = 'Poshiya';
    _emailController.text = 'ishitaposhiya@gmail.com';
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
        // centerTitle: true,
        // leading: IconButton(onPressed: () {
        //   Navigator.pop(context);
        // }, icon: SvgPicture.asset(
        //   "assets/images/ios-back-arrow.svg",
        //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // ),),
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
                      child: Icon(Icons.person,size: 40,),
                      // backgroundImage: _profilePicUrl.isNotEmpty
                      //     ? FileImage(File(_profilePicUrl)) // Show selected image
                      //     : NetworkImage(''
                    //  ), // Default profile image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black12,
                        child: IconButton(
                          icon: Icon(Icons.edit,size: 18,color: Colors.grey.shade600,),
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
                onPressed: () {
                  // Handle saving changes
                  print('Saved: ${_firstNameController.text} ${_lastNameController.text} ${_emailController.text}');
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
