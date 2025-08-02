import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/woop_provider.dart';
import '../../core/providers/timer_provider.dart';
import 'woop_list_page.dart';
import 'woop_form_page.dart';
import 'timer_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TouchGrass'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TimerPage()),
            ),
            tooltip: 'Focus Timer',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WoopListPage()),
            ),
            tooltip: 'View All WOOPs',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact Welcome Header
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.grass,
                        size: 32,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to TouchGrass!',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your 24-hour craving support companion',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 12),
            
            // Compact Stats Row
            Consumer(
              builder: (context, ref, child) {
                final statsAsync = ref.watch(woopStatsProvider);
                
                return statsAsync.when(
                  data: (stats) => Row(
                    children: [
                      Expanded(
                        child: _buildCompactStatCard(
                          'WOOPs',
                          stats['total']!,
                          Icons.psychology,
                          theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactStatCard(
                          'Active',
                          stats['pending']!,
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactStatCard(
                          'Done',
                          stats['completed']!,
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(height: 60),
                  error: (error, stack) => const SizedBox.shrink(),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Active Timer Section
            Consumer(
              builder: (context, ref, child) {
                final timerAsync = ref.watch(timerProvider);
                
                return timerAsync.when(
                  data: (session) => session != null 
                      ? _buildActiveTimerCard(context, session)
                      : _buildStartTimerCard(context),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Compact Quick Actions Grid
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'New WOOP',
                    Icons.add_circle,
                    theme.colorScheme.primary,
                    () => _createNewWoop(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'View WOOPs',
                    Icons.list,
                    Colors.blue,
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const WoopListPage()),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Compact WOOP Explanation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WOOP Method',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildCompactWoopItem('W', 'Wish', Colors.amber),
                        _buildCompactWoopItem('O', 'Outcome', Colors.green),
                        _buildCompactWoopItem('O', 'Obstacle', Colors.orange),
                        _buildCompactWoopItem('P', 'Plan', Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatCard(String label, int value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactWoopItem(String letter, String title, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWoopExplanationItem(
    String letter,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimerCard(BuildContext context, dynamic session) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TimerPage()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: session.progressPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                session.formattedRemaining,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartTimerCard(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TimerPage()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Start Focus Timer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNewWoop(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const WoopFormPage(),
      ),
    );
    
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WOOP created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
