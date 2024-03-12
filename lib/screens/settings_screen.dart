import 'package:demo_alumnet/components/my_list_tile.dart';
import 'package:demo_alumnet/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        // Remove the IconButton for notifications
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('COMMUNITY'),
                ],
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.school),
                text: "College",
                onTap: () {
                  launchUrl(Uri.parse('https://vesit.ves.ac.in/'));
                },
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.man_3),
                text: "Faculty",
                onTap: () {
                  launchUrl(Uri.parse('https://vesit.ves.ac.in/faculty/IT'));
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('CELLS'),
                ],
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.webhook),
                text: "Institute's Innovation Council",
                onTap: () {
                  launchUrl(Uri.parse('https://vesit.ves.ac.in/iic#overview'));
                },
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.web_asset),
                text: "VESIT Renaissance Cell",
                onTap: () {
                  launchUrl(
                      Uri.parse('https://vesit.ves.ac.in/student_corner/vrc'));
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Activities'),
                ],
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.auto_graph),
                text: "Placements",
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://vesit.ves.ac.in/placements/statistics'));
                },
              ),
              MyCustomListTile(
                padding: 10,
                icon: const Icon(Icons.event),
                text: "Events",
                onTap: () {
                  launchUrl(
                      Uri.parse('https://vesit.ves.ac.in/news_events_viewall'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
