import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

import '../../../flight_module/components/toast.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void copyToClipboard(String text) {
      FlutterClipboard.copy(text)
          .then((value) => showToast(context,
              textToast: 'Email copied to clipboard',
              colorToast: Colors.grey,
              imagePath: 'lib/icons/email.png'))
          .catchError((error) => print('Error copying to clipboard: $error'));
    }

    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to our application for recording aviation data! Your privacy is important to us, and we are committed to protecting your personal information. Please read our Privacy Policy carefully to understand how we collect, use, and safeguard your data.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '1. Information collection: We may collect personal information such as your name, email address, and date of birth when you register with our application.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '2. Data usage: Your personal information may be used to provide and improve our services, communicate with you, and personalize your experience.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '3. Data security: We employ industry-standard security measures to protect your data from unauthorized access, alteration, disclosure, or destruction.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '4. Third-party services: We may use third-party services for analytics, advertising, and other purposes. These services may have their own privacy policies, and we encourage you to review them.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '5. Policy changes: We reserve the right to update or modify this Privacy Policy at any time. We will notify you of any changes by posting the new Privacy Policy on this page.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'By using our application, you consent to the terms of this Privacy Policy.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'If you have any questions or concerns regarding our Privacy Policy, please contact us.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.content_copy, color: Colors.white),
                  onPressed: () {
                    copyToClipboard(
                      'jfelber2001@gmail.com',
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Center(
              child: Text(
                'Your Sky Journal team !',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
