import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSection(context, '✅ Data Collection', [
              'No personal data is collected or shared online.',
              'Your data is stored locally using SQLite and Shared Preferences.',
              'All saved data is deleted upon uninstallation.',
            ]),
            _buildSection(context, '🛠 How We Use Your Data', [
              'Your username, email, and game history are saved only on your device.',
              'No data is sent to external servers or shared with others.',
            ]),
            _buildSection(context, '📢 Advertisements', [
              'The App displays banner and full-screen ads.',
              'Ads require an internet connection.',
              'If offline, the App will ask you to connect to the internet to show ads.',
            ]),
            _buildSection(context, '🎮 Game Modes', [
              'Single Player: Play against a bot (offline).',
              'Two Player: Play with a friend on the same device.',
            ]),
            _buildSection(context, '🗑 Data Deletion', [
              'If you uninstall the App, all saved data, including game stats and user details, will be deleted permanently.',
            ]),
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Builds the Privacy Policy Header with Title & Last Updated Date**
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '📅 Last Updated: March 23, 2025',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// 🔹 **Reusable Card Section**
  Widget _buildSection(
      BuildContext context, String title, List<String> points) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 10),
            _buildSectionContent(context, points),
          ],
        ),
      ),
    );
  }

  /// 🔹 **List of Points Inside Each Section**
  Widget _buildSectionContent(BuildContext context, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Text(
                  point,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 🔹 **Builds Contact Us Section with Email Button Instead of Plain Text**
  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📞 Contact Us',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'For any concerns, feel free to contact us:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () =>
                    launchUrl(Uri.parse('mailto:manavpalet13402003@gmail.com')),
                icon: const Icon(Icons.email),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
