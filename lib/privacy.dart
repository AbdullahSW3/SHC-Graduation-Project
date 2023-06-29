import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'ProfileScreen.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            LineAwesomeIcons.angle_left,
            size: 35,
          ),
          color: Colors.blueAccent,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: Theme.of(context).textTheme.headline4?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Colors.blueAccent,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Last Updated: [6/12/2023]\n\n'
              'Welcome to SHC! This Privacy Policy explains how we collect, use, and protect the information you provide while using our application. By accessing or using SHC, you acknowledge that you have read, understood, and agreed to the terms and practices described in this Privacy Policy.\n\n'
              'Information We Collect\n'
              '1.1 Personal Information: When you use SHC, we may collect certain personal information that you provide voluntarily, such as your name, email address, and any other information you choose to provide during the registration or account creation process.\n\n'
              '1.2 Medical Information: SHC is designed to provide general information and resources related to health and wellness. However, it is important to note that SHC does not eliminate the need for professional medical advice, diagnosis, or treatment. Therefore, we do not collect or store any sensitive medical information or provide personalized medical advice.\n\n'
              'Use of Information\n'
              '2.1 Personal Information: We may use the personal information you provide to personalize your experience within SHC, communicate with you regarding your account, respond to your inquiries or requests, and provide you with relevant updates and information related to our services.\n\n'
              '2.2 Database Storage: All information you provide within SHC is securely stored in our databases. We employ industry-standard security measures to protect your personal information and prevent unauthorized access, disclosure, alteration, or destruction of your data.\n\n'
              'Sharing of Information\n'
              '3.1 Third-Party Service Providers: We may engage trusted third-party service providers to assist us in delivering and improving our services. These service providers may have access to your personal information solely for the purpose of performing their services on our behalf and are obligated not to disclose or use it for any other purpose.\n\n'
              '3.2 Legal Requirements: We may disclose your personal information if required to do so by law or in the good faith belief that such action is necessary to comply with legal obligations, protect and defend our rights or property, investigate or prevent fraud, or protect the safety of our users or the public.\n\n'
              'Data Retention\n'
              'We will retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law. We will securely delete or anonymize your personal information once it is no longer needed.\n\n'
              'Your Choices and Rights\n'
              'You have the right to access, update, correct, or delete the personal information you provide within SHC. You can exercise these rights by contacting us at SHC@gmail.com. Please note that we may retain certain information as required by law or for legitimate business purposes.\n\n'
              "Children's Privacy\n"
              'SHC is not intended for use by individuals under the age of 18 . We do not knowingly collect personal information from children under the specified age. If we become aware that we have inadvertently collected personal information from a child under the specified age, we will take steps to delete it.\n\n'
              'Changes to this Privacy Policy\n'
              'We reserve the right to modify or update this Privacy Policy at any time. If we make material changes, we will notify you by email or by posting a prominent notice within SHC prior to the change becoming effective. Your continued use of SHC after any modifications or updates to this Privacy Policy constitutes your acceptance of such changes.\n\n'
              'Contact Us\n'
              'If you have any questions or concerns about this Privacy Policy or our practices regarding your personal information, please contact us at SHC@gmail.com. We will make reasonable efforts to address your inquiry promptly.\n\n'
              'Thank you for using SHC. We are committed to protecting your privacy and providing you with a secure and enjoyable experience.',
        ),
      ),
    );
  }
}
