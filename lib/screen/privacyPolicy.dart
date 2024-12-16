import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
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
        child: SingleChildScrollView(  // Scrollable view in case content is long
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Policy Title
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Introduction Section
              Text(
                textAlign: TextAlign.justify,
                'At Our App, we value your privacy and are committed to protecting your personal data. This privacy policy outlines how we collect, use, and safeguard your information when you use our app.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Collection of Information Section
              Text(
                '1. Collection of Information',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.justify,
                'We may collect personal information such as your name, email address, and documents uploaded to the app. This information helps us provide a better experience for you.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Use of Information Section
              Text(
                '2. Use of Information',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.justify,
                'Your information will be used solely for the purpose of enhancing your experience within the app. We do not share your information with third parties unless required by law.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Security of Information Section
              Text(
                '3. Security of Information',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.justify,
                'We take reasonable precautions to ensure the security of your data. However, no system is completely secure, and we cannot guarantee the security of your data transmitted over the internet.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Contact Information Section
              Text(
                '4. Contact Us',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.justify,
                'If you have any questions or concerns about this privacy policy, please contact us at support@documentmanager.com.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Footer or Last Section
              Text(
                textAlign: TextAlign.justify,
                'By using our app, you agree to the terms and conditions outlined in this privacy policy.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
