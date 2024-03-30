import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

import '../../../flight_module/components/toast.dart';

class TermsOfUsePage extends StatelessWidget {
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
        title: 'Terms of Use',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to our application for recording aviation data! Before using this application, please carefully read the following Terms of Use:',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Text(
              '1. Permission to use the application: By using this application, you agree to these Terms of Use. If you do not agree with them, do not use this application.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '2. Responsibility for data: You are fully responsible for all data and information you input into this application. We recommend ensuring the accuracy and currency of all data.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '3. Privacy protection: Your personal data will be protected in accordance with our Privacy Policy. We will not provide your data to third parties without your consent.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '4. Changes in terms: These Terms of Use may be updated occasionally. By continuing to use the application with the new terms, you agree to these changes.',
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
                    'If you have any questions or concerns regarding these Terms of Use, feel free to contact us.',
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
