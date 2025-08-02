import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/timer_provider.dart';
import '../../core/providers/woop_provider.dart';
import '../../core/models/timer_session.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerAsync = ref.watch(timerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showTimerHistory(context),
            tooltip: 'Timer History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showTimerSettings(context),
            tooltip: 'Timer Settings',
          ),
        ],
      ),
      body: timerAsync.when(
        data: (session) => _buildTimerContent(context, session),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(timerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: timerAsync.whenOrNull(
        data: (session) => session == null ? _buildCreateTimerFAB() : null,
      ),
    );
  }

  Widget _buildTimerContent(BuildContext context, TimerSession? session) {
    if (session == null) {
      return _buildNoTimerState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Timer Name and WOOP Link
          _buildTimerHeader(session),
          
          const SizedBox(height: 32),
          
          // Circular Timer Display
          _buildCircularTimer(session),
          
          const SizedBox(height: 32),
          
          // Timer Controls
          _buildTimerControls(session),
          
          const SizedBox(height: 24),
          
          // Timer Stats
          _buildTimerStats(session),
        ],
      ),
    );
  }

  Widget _buildNoTimerState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Timer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create a focus timer to start tracking your productive time',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Quick timer presets
          _buildQuickTimers(),
        ],
      ),
    );
  }

  Widget _buildQuickTimers() {
    final presets = ref.watch(timerPresetsProvider);
    
    return Column(
      children: [
        Text(
          'Quick Timers',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: presets.map((preset) => _buildPresetCard(preset)).toList(),
        ),
      ],
    );
  }

  Widget _buildPresetCard(TimerPreset preset) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _createQuickTimer(preset),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getPresetIcon(preset.name),
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                preset.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                preset.duration.inMinutes > 0 
                    ? '${preset.duration.inMinutes}m'
                    : '${preset.duration.inSeconds}s',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPresetIcon(String name) {
    switch (name.toLowerCase()) {
      case 'focus session':
        return Icons.psychology;
      case 'short break':
        return Icons.coffee;
      case 'long break':
        return Icons.lunch_dining;
      case 'deep work':
        return Icons.work;
      case 'exercise':
        return Icons.fitness_center;
      case 'meditation':
        return Icons.self_improvement;
      default:
        return Icons.timer;
    }
  }

  Widget _buildTimerHeader(TimerSession session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              session.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (session.woopId != null) ...[
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final woopAsync = ref.watch(woopProvider);
                  return woopAsync.whenOrNull(
                    data: (woops) {
                      final woop = woops.where((w) => w.id == session.woopId).firstOrNull;
                      if (woop != null) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.psychology, size: 16, color: Colors.amber[700]),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'WOOP: ${woop.wish}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ) ?? const SizedBox.shrink();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTimer(TimerSession session) {
    final progress = session.progressPercentage;
    final isRunning = session.state == TimerState.running;
    
    // Start/stop pulse animation based on timer state
    if (isRunning && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!isRunning && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isRunning ? _pulseAnimation.value : 1.0,
          child: SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              children: [
                // Background circle
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
                  ),
                ),
                
                // Progress circle
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTimerColor(session.state),
                    ),
                  ),
                ),
                
                // Center content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session.formattedRemaining,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTimerStateText(session.state),
                        style: TextStyle(
                          color: _getTimerColor(session.state),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toInt()}% Complete',
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
          ),
        );
      },
    );
  }

  Color _getTimerColor(TimerState state) {
    switch (state) {
      case TimerState.initial:
        return Colors.grey;
      case TimerState.running:
        return Colors.green;
      case TimerState.paused:
        return Colors.orange;
      case TimerState.completed:
        return Colors.blue;
    }
  }

  String _getTimerStateText(TimerState state) {
    switch (state) {
      case TimerState.initial:
        return 'Ready to Start';
      case TimerState.running:
        return 'Focus Time';
      case TimerState.paused:
        return 'Paused';
      case TimerState.completed:
        return 'Completed!';
    }
  }

  Widget _buildTimerControls(TimerSession session) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reset button
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: session.state == TimerState.initial ? null : () => _resetTimer(),
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.grey[700],
          child: const Icon(Icons.refresh),
        ),
        
        // Main play/pause button
        FloatingActionButton.large(
          heroTag: 'main',
          onPressed: () => _toggleTimer(session),
          backgroundColor: _getTimerColor(session.state),
          foregroundColor: Colors.white,
          child: Icon(
            _getMainButtonIcon(session.state),
            size: 36,
          ),
        ),
        
        // Stop button
        FloatingActionButton(
          heroTag: 'stop',
          onPressed: session.state == TimerState.initial ? null : () => _stopTimer(),
          backgroundColor: Colors.red[100],
          foregroundColor: Colors.red[700],
          child: const Icon(Icons.stop),
        ),
      ],
    );
  }

  IconData _getMainButtonIcon(TimerState state) {
    switch (state) {
      case TimerState.initial:
      case TimerState.paused:
        return Icons.play_arrow;
      case TimerState.running:
        return Icons.pause;
      case TimerState.completed:
        return Icons.replay;
    }
  }

  Widget _buildTimerStats(TimerSession session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Target', session.formattedTarget, Icons.flag),
                _buildStatItem('Elapsed', session.formattedElapsed, Icons.timer),
                _buildStatItem('Remaining', session.formattedRemaining, Icons.hourglass_empty),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateTimerFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateTimerDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('New Timer'),
    );
  }

  // Timer actions
  void _createQuickTimer(TimerPreset preset) async {
    try {
      await ref.read(timerProvider.notifier).createTimer(
        name: preset.name,
        targetDuration: preset.duration,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating timer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleTimer(TimerSession session) async {
    try {
      if (session.state == TimerState.running) {
        await ref.read(timerProvider.notifier).pauseTimer();
      } else {
        await ref.read(timerProvider.notifier).startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error controlling timer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetTimer() async {
    try {
      await ref.read(timerProvider.notifier).resetTimer();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting timer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _stopTimer() async {
    // Show confirmation dialog
    final shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer'),
        content: const Text('Are you sure you want to stop this timer? Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Stop'),
          ),
        ],
      ),
    );

    if (shouldStop == true) {
      try {
        await ref.read(timerProvider.notifier).stopTimer();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error stopping timer: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showCreateTimerDialog(BuildContext context) {
    // TODO: Implement create timer dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom timer creation coming soon!')),
    );
  }

  void _showTimerHistory(BuildContext context) {
    // TODO: Implement timer history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timer history coming soon!')),
    );
  }

  void _showTimerSettings(BuildContext context) {
    // TODO: Implement timer settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timer settings coming soon!')),
    );
  }
}