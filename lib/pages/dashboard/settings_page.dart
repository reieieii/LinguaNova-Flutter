import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _dailyReminder = true;
  double _speechRate = 0.9;
  String _dailyGoal = '15 minutes';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Preferences',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your learning experience, notifications, and audio settings.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 32),

          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audio & Speech Settings',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Sound Effects & TTS', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Enable audio pronunciation and speech synthesis', style: TextStyle(color: AppColors.textMuted)),
                  value: _soundEnabled,
                  activeTrackColor: AppColors.brand700,
                  activeThumbColor: AppColors.brand300,
                  onChanged: (val) => setState(() => _soundEnabled = val),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speech Rate: ${_speechRate.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _speechRate,
                      min: 0.5,
                      max: 1.5,
                      divisions: 10,
                      activeColor: AppColors.brand300,
                      inactiveColor: Colors.white10,
                      onChanged: (val) => setState(() => _speechRate = val),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 32),

                const Text(
                  'Daily Learning Goal',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _dailyGoal,
                  dropdownColor: AppColors.dark800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: '5 minutes', child: Text('Casual: 5 minutes / day')),
                    DropdownMenuItem(value: '15 minutes', child: Text('Regular: 15 minutes / day')),
                    DropdownMenuItem(value: '30 minutes', child: Text('Serious: 30 minutes / day')),
                    DropdownMenuItem(value: '60 minutes', child: Text('Intense: 60 minutes / day')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _dailyGoal = val);
                  },
                ),
                const Divider(color: Colors.white10, height: 32),

                SwitchListTile(
                  title: const Text('Daily Reminder Notifications', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Receive notifications to maintain your daily streak', style: TextStyle(color: AppColors.textMuted)),
                  value: _dailyReminder,
                  activeTrackColor: AppColors.brand700,
                  activeThumbColor: AppColors.brand300,
                  onChanged: (val) => setState(() => _dailyReminder = val),
                ),
                const SizedBox(height: 24),

                GlassButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings saved successfully!')),
                    );
                  },
                  variant: GlassButtonVariant.primary,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
