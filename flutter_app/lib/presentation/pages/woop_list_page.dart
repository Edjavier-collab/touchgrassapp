import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/woop_provider.dart';
import '../../core/models/woop_entry.dart';
import 'woop_form_page.dart';

class WoopListPage extends ConsumerStatefulWidget {
  const WoopListPage({super.key});

  @override
  ConsumerState<WoopListPage> createState() => _WoopListPageState();
}

class _WoopListPageState extends ConsumerState<WoopListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My WOOPs'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(woopProvider.notifier).refresh(),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export Data'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear_completed',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Clear Completed'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: ListTile(
                  leading: Icon(Icons.delete_sweep),
                  title: Text('Clear All'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
                      tabs: const [
              Tab(text: 'All', icon: Icon(Icons.list)),
              Tab(text: 'Active', icon: Icon(Icons.pending_actions)),
              Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
            ],
        ),
      ),
      body: Column(
        children: [
          // Stats Card
          _buildStatsCard(),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllWoopsTab(),
                _buildPendingWoopsTab(),
                _buildCompletedWoopsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewWoop,
        icon: const Icon(Icons.add),
        label: const Text('New WOOP'),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Consumer(
      builder: (context, ref, child) {
        final statsAsync = ref.watch(woopStatsProvider);
        
        return statsAsync.when(
          data: (stats) => Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Total',
                    stats['total']!,
                    Icons.format_list_bulleted,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'Active',
                    stats['pending']!,
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'Completed',
                    stats['completed']!,
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, stack) => Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error loading stats: $error'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
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

  Widget _buildAllWoopsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final woopAsync = ref.watch(woopProvider);
        
        return woopAsync.when(
          data: (entries) => _buildWoopList(entries),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text('Error loading WOOPs: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(woopProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingWoopsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final pendingAsync = ref.watch(pendingWoopEntriesProvider);
        
        return pendingAsync.when(
          data: (entries) => _buildWoopList(entries),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
    );
  }

  Widget _buildCompletedWoopsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final completedAsync = ref.watch(completedWoopEntriesProvider);
        
        return completedAsync.when(
          data: (entries) => _buildWoopList(entries),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
    );
  }

  Widget _buildWoopList(List<WoopEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No WOOPs yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first WOOP to get started!',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _createNewWoop,
              icon: const Icon(Icons.add),
              label: const Text('Create WOOP'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(woopProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _buildWoopCard(entry);
        },
      ),
    );
  }

  Widget _buildWoopCard(WoopEntry entry) {
    final dateFormat = DateFormat('MMM d, y \'at\' h:mm a');
    
    return Card(
      elevation: entry.isCompleted ? 1 : 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editWoop(entry.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and actions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.wish,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: entry.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      entry.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: entry.isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => _toggleCompletion(entry.id),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // WOOP Details
              _buildWoopDetail('Outcome', entry.outcome, Icons.emoji_emotions, Colors.green),
              const SizedBox(height: 8),
              _buildWoopDetail('Obstacle', entry.obstacle, Icons.warning, Colors.orange),
              const SizedBox(height: 8),
              _buildWoopDetail('Plan', entry.plan, Icons.lightbulb, Colors.blue),
              
              const SizedBox(height: 12),
              
              // Footer with date and status
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Created ${dateFormat.format(entry.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (entry.isCompleted && entry.completedAt != null) ...[
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed ${dateFormat.format(entry.completedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWoopDetail(String label, String content, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                content,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createNewWoop() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const WoopFormPage(),
      ),
    );
    
    if (result == true && context.mounted) {
      // Success - the provider will automatically update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WOOP created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _editWoop(String id) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => WoopFormPage(editingId: id),
      ),
    );
    
    if (result == true && context.mounted) {
      // Success - the provider will automatically update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WOOP updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _toggleCompletion(String id) async {
    try {
      await ref.read(woopProvider.notifier).toggleCompletion(id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating WOOP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        _exportData();
        break;
      case 'clear_completed':
        _clearCompleted();
        break;
      case 'clear_all':
        _clearAll();
        break;
    }
  }

  void _exportData() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon!'),
      ),
    );
  }

  void _clearCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed WOOPs'),
        content: const Text('Are you sure you want to remove all completed WOOPs? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: Implement clear completed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clear completed feature coming soon!')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All WOOPs'),
        content: const Text('Are you sure you want to remove ALL WOOPs? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(woopProvider.notifier).clearAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All WOOPs cleared!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error clearing WOOPs: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}