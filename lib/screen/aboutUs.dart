import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import 'contactProfile.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us", style: TextStyle(color: Colors.white)),
        backgroundColor: Themer.gradient1,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildAppOverview(),
            SizedBox(height: 20),
            _buildCompanyInfo(),
            SizedBox(height: 20),
            _buildContactInfo(),
            SizedBox(height: 20),
            _buildSocialLinks(),
            SizedBox(height: 20),
            _buildVersionInfo(),
            SizedBox(height: 40),
            _buildCallToAction(context),
          ],
        ),
      ),
    );
  }

  // Header with app logo
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          // Icon(Icons.account_box, size: 100, color: Themer.gradient1),
          Center(
            child: Image.asset('assets/images/document2.png', height: 100, width: 100),
          ),
          SizedBox(height: 10),
          Text(
            'Document Manager App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Brief app overview
  Widget _buildAppOverview() {
    return Text(
      'The Document Manager app is a powerful tool designed to help users efficiently organize, manage, and access documents on their devices. With features like quick search, document categorization, and sharing options, it provides a seamless experience for managing your files.',
      style: TextStyle(fontSize: 16, color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }

  // Company or team information
  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Our Team',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Themer.gradient1),
        ),
        SizedBox(height: 10),
        Text(
          'Our team at XYZ Tech is dedicated to building intuitive and user-friendly tools for managing digital content. With years of experience in app development, we strive to provide our users with seamless and efficient solutions.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  // Contact information section
  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Themer.gradient1),
        ),
        SizedBox(height: 10),
        Text(
          'Email: support@documentmanager.com',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          'Phone: +1 234 567 890',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  // Social media links
  Widget _buildSocialLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Themer.gradient1),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.facebook, color: Themer.gradient1),
              onPressed: () {
                // Open Facebook
              },
            ),
            IconButton(
              icon: Icon(Icons.language, color: Themer.gradient1),
              onPressed: () {
                // Open Twitter
              },
            ),
            IconButton(
              icon: Icon(Icons.facebook, color: Themer.gradient1),
              onPressed: () {
                // Open LinkedIn
              },
            ),
          ],
        ),
      ],
    );
  }

  // App version information
  Widget _buildVersionInfo() {
    return Text(
      'App Version: 1.0.0',
      style: TextStyle(fontSize: 16, color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }

  // Call to Action button (e.g., "Visit Website" or "Contact Us")
  Widget _buildCallToAction(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to a contact page or website
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactProfilePage()), // You can replace with your actual page
        );
      },
      child: Text('Get in Touch', style: TextStyle(fontSize: 18, color: Themer.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Themer.gradient1, // Match your theme color
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}


