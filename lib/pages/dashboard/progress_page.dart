import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Progress & Analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track your study metrics, daily activity, and skill development.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Skill Progress Bars Card
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Skill Mastery Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _skillProgress('Vocabulary', 0.82, AppColors.brand300),
                const SizedBox(height: 16),
                _skillProgress('Grammar & Structure', 0.65, Colors.lightBlueAccent),
                const SizedBox(height: 16),
                _skillProgress('Listening Comprehension', 0.74, Colors.amberAccent),
                const SizedBox(height: 16),
                _skillProgress('Speaking & Pronunciation', 0.58, Colors.greenAccent),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Weekly Activity Log Card
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Study Activity (Minutes)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _BarItem(day: 'Mon', minutes: 45, heightRatio: 0.6),
                    _BarItem(day: 'Tue', minutes: 60, heightRatio: 0.8),
                    _BarItem(day: 'Wed', minutes: 30, heightRatio: 0.4),
                    _BarItem(day: 'Thu', minutes: 75, heightRatio: 1.0),
                    _BarItem(day: 'Fri', minutes: 50, heightRatio: 0.65),
                    _BarItem(day: 'Sat', minutes: 40, heightRatio: 0.55),
                    _BarItem(day: 'Sun', minutes: 25, heightRatio: 0.35),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillProgress(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: Colors.white10,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.day,
    required this.minutes,
    required this.heightRatio,
  });

  final String day;
  final int minutes;
  final double heightRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${minutes}m',
          style: const TextStyle(color: AppColors.brand300, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 120 * heightRatio,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.brand700, AppColors.brand300],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
