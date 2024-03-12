import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            _buildSection('Address',
                'Vivekananda Educational Society Institute of Technology, Hashu advani memorial complex, collectors colony chembur 400074 mumbai maharashtra india'),

            // Phone/Email Section
            _buildSection('Phone/Email', '+022-25227460\nves@ves.ac.in'),

            // Visit Us Section
            _buildSection('Visit Us', '9-5 pm weekdays\n12-3 Saturdays'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String heading, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text(
          heading,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),

        // Content
        Text(
          content,
          style: const TextStyle(color: Colors.black),
        ),

        // Line Breaker
        const Divider(
          color: Colors.black,
          height: 20,
          thickness: 2,
        ),

        // Space between sections
        const SizedBox(height: 16),
      ],
    );
  }
}
