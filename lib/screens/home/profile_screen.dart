import 'package:dubts/core/models/user_model.dart';
import 'package:dubts/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red.shade100,
              child: user?.photoURL != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        user!.photoURL!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.red,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'Guest User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              user?.email ?? 'No email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileCard(
              title: 'Account Information',
              children: [
                _buildProfileItem(
                  icon: Icons.person,
                  title: 'Name',
                  value: user?.displayName ?? 'Guest User',
                ),
                _buildProfileItem(
                  icon: Icons.email,
                  title: 'Email',
                  value: user?.email ?? 'No email',
                ),
                _buildProfileItem(
                  icon: Icons.verified_user,
                  title: 'Account Type',
                  value: user?.email != null ? 'Registered User' : 'Guest',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileCard(
              title: 'App Settings',
              children: [
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  trailing: Switch(
                    value: true,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      // Handle notification settings
                    },
                  ),
                ),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: const Text('English'),
                  onTap: () {
                    // Handle language settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: false,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      // Handle theme settings
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileCard(
              title: 'About',
              children: [
                _buildSettingsItem(
                  icon: Icons.info,
                  title: 'App Version',
                  trailing: const Text('1.0.0'),
                ),
                _buildSettingsItem(
                  icon: Icons.policy,
                  title: 'Privacy Policy',
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  onTap: () {
                    // Navigate to terms of service
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Divider(color: Colors.red),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
