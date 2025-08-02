import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/woop_provider.dart';

class WoopFormPage extends ConsumerStatefulWidget {
  final String? editingId;

  const WoopFormPage({super.key, this.editingId});

  @override
  ConsumerState<WoopFormPage> createState() => _WoopFormPageState();
}

class _WoopFormPageState extends ConsumerState<WoopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _wishController = TextEditingController();
  final _outcomeController = TextEditingController();
  final _obstacleController = TextEditingController();
  final _planController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    // If editing, load the entry data
    if (widget.editingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadEntryForEditing();
      });
    }
  }

  Future<void> _loadEntryForEditing() async {
    final woopState = ref.read(woopProvider);
    woopState.whenData((entries) {
      final entry = entries.where((e) => e.id == widget.editingId).firstOrNull;
      if (entry != null) {
        _wishController.text = entry.wish;
        _outcomeController.text = entry.outcome;
        _obstacleController.text = entry.obstacle;
        _planController.text = entry.plan;
        
        // Update form provider
        final formNotifier = ref.read(woopFormProvider.notifier);
        formNotifier.setEntry(entry);
      }
    });
  }

  @override
  void dispose() {
    _wishController.dispose();
    _outcomeController.dispose();
    _obstacleController.dispose();
    _planController.dispose();
    super.dispose();
  }

  Future<void> _saveWoop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final formNotifier = ref.read(woopFormProvider.notifier);
      final woopNotifier = ref.read(woopProvider.notifier);
      
      // Update form state with current values
      formNotifier.updateWish(_wishController.text.trim());
      formNotifier.updateOutcome(_outcomeController.text.trim());
      formNotifier.updateObstacle(_obstacleController.text.trim());
      formNotifier.updatePlan(_planController.text.trim());

      // Create/update the entry
      final entry = formNotifier.toWoopEntry();
      
      if (formNotifier.isEditing) {
        await woopNotifier.updateEntry(entry);
      } else {
        await woopNotifier.addEntry(entry);
      }

      // Clear form and navigate back
      formNotifier.clear();
      
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving WOOP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.editingId != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit WOOP' : 'Create WOOP'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // WOOP Explanation Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WOOP Method',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'WOOP is a science-based mental strategy that helps you achieve your goals.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Wish Field
              _buildWoopField(
                controller: _wishController,
                label: 'Wish',
                hint: 'What do you want to achieve?',
                icon: Icons.star,
                color: Colors.amber,
                description: 'Your goal or aspiration. Be specific and positive.',
                onChanged: (value) => ref.read(woopFormProvider.notifier).updateWish(value),
              ),

              const SizedBox(height: 20),

              // Outcome Field
              _buildWoopField(
                controller: _outcomeController,
                label: 'Outcome',
                hint: 'How will you feel when you achieve this?',
                icon: Icons.emoji_emotions,
                color: Colors.green,
                description: 'The positive feeling or benefit you\'ll experience.',
                onChanged: (value) => ref.read(woopFormProvider.notifier).updateOutcome(value),
              ),

              const SizedBox(height: 20),

              // Obstacle Field
              _buildWoopField(
                controller: _obstacleController,
                label: 'Obstacle',
                hint: 'What might prevent you from achieving this?',
                icon: Icons.warning,
                color: Colors.orange,
                description: 'The main barrier or challenge you might face.',
                onChanged: (value) => ref.read(woopFormProvider.notifier).updateObstacle(value),
              ),

              const SizedBox(height: 20),

              // Plan Field
              _buildWoopField(
                controller: _planController,
                label: 'Plan',
                hint: 'If obstacle occurs, then I will...',
                icon: Icons.lightbulb,
                color: Colors.blue,
                description: 'Your if-then plan to overcome the obstacle.',
                onChanged: (value) => ref.read(woopFormProvider.notifier).updatePlan(value),
              ),

              const SizedBox(height: 32),

              // Save Button
              FilledButton.icon(
                onPressed: _isSubmitting ? null : _saveWoop,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(isEditing ? Icons.save : Icons.add),
                label: Text(_isSubmitting 
                    ? 'Saving...' 
                    : (isEditing ? 'Update WOOP' : 'Create WOOP')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              OutlinedButton(
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWoopField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    required String description,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon, color: color),
          ),
          maxLines: 3,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your $label';
            }
            if (value.trim().length < 3) {
              return '$label must be at least 3 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete WOOP'),
        content: const Text('Are you sure you want to delete this WOOP? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              
              try {
                await ref.read(woopProvider.notifier).deleteEntry(widget.editingId!);
                if (mounted && context.mounted) {
                  Navigator.of(context).pop(true); // Navigate back with success
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting WOOP: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}