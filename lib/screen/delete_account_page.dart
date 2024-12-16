import 'package:document_manager/global/global.dart';
import 'package:document_manager/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DeleteAccountPage extends StatefulWidget{
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _confirmNameController = TextEditingController();

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete your account?",style: TextStyle(fontSize: 18),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Text("To confirm, please type your first name \"${Global.userFirstName}\" below."),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  children: [
                    TextSpan(text: "To confirm, please type your first name "),
                    TextSpan(
                      text: "${Global.userFirstName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " below."),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Themer.gradient1,
              ),
              child: Text("Delete",style: TextStyle(color: Themer.white),),
              onPressed: () {
                // Perform delete account action if the name matches
                if (_confirmNameController.text == Global.userFirstName) { // Replace with actual user name or variable
                  Navigator.of(context).pop();
                  _deleteAccount();
                } else {
                  // Show an error if the name doesn't match
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Name does not match. Please try again."),
                      backgroundColor: Themer.gradient1,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    // Implement account deletion logic here
    print("Account deleted.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themer.gradient1,
        title: Text(
          'Delete Account'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Reason for delete account",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showDeleteConfirmationDialog,
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Themer.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Themer.buttonColor.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
