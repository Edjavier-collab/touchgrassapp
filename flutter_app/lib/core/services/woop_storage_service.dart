import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/woop_entry.dart';

class WoopStorageService {
  static const String _woopEntriesKey = 'woop_entries';
  
  late final SharedPreferences _prefs;
  bool _isInitialized = false;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Ensure service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('WoopStorageService not initialized. Call initialize() first.');
    }
  }

  // Save a new WOOP entry
  Future<void> saveWoopEntry(WoopEntry entry) async {
    _ensureInitialized();
    
    final entries = await getAllWoopEntries();
    
    // Remove existing entry with same ID if it exists
    entries.removeWhere((e) => e.id == entry.id);
    
    // Add the new/updated entry
    entries.add(entry);
    
    // Sort by creation date (newest first)
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Save to storage
    await _saveEntriesToStorage(entries);
  }

  // Get all WOOP entries
  Future<List<WoopEntry>> getAllWoopEntries() async {
    _ensureInitialized();
    
    final String? entriesJson = _prefs.getString(_woopEntriesKey);
    
    if (entriesJson == null || entriesJson.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> entriesList = json.decode(entriesJson);
      return entriesList
          .map((entryJson) => WoopEntry.fromJson(entryJson))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list and clear storage
      await clearAllEntries();
      return [];
    }
  }

  // Get a specific WOOP entry by ID
  Future<WoopEntry?> getWoopEntry(String id) async {
    _ensureInitialized();
    
    final entries = await getAllWoopEntries();
    
    try {
      return entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete a WOOP entry
  Future<void> deleteWoopEntry(String id) async {
    _ensureInitialized();
    
    final entries = await getAllWoopEntries();
    entries.removeWhere((entry) => entry.id == id);
    
    await _saveEntriesToStorage(entries);
  }

  // Mark a WOOP entry as completed/uncompleted
  Future<void> toggleWoopCompletion(String id) async {
    _ensureInitialized();
    
    final entries = await getAllWoopEntries();
    final entryIndex = entries.indexWhere((entry) => entry.id == id);
    
    if (entryIndex != -1) {
      final entry = entries[entryIndex];
      final updatedEntry = entry.copyWith(
        isCompleted: !entry.isCompleted,
        completedAt: !entry.isCompleted ? DateTime.now() : null,
      );
      
      entries[entryIndex] = updatedEntry;
      await _saveEntriesToStorage(entries);
    }
  }

  // Get completed WOOP entries
  Future<List<WoopEntry>> getCompletedEntries() async {
    final entries = await getAllWoopEntries();
    return entries.where((entry) => entry.isCompleted).toList();
  }

  // Get pending WOOP entries
  Future<List<WoopEntry>> getPendingEntries() async {
    final entries = await getAllWoopEntries();
    return entries.where((entry) => !entry.isCompleted).toList();
  }

  // Clear all WOOP entries
  Future<void> clearAllEntries() async {
    _ensureInitialized();
    await _prefs.remove(_woopEntriesKey);
  }

  // Get total count of entries
  Future<int> getEntryCount() async {
    final entries = await getAllWoopEntries();
    return entries.length;
  }

  // Get completed count
  Future<int> getCompletedCount() async {
    final entries = await getCompletedEntries();
    return entries.length;
  }

  // Private helper to save entries to storage
  Future<void> _saveEntriesToStorage(List<WoopEntry> entries) async {
    final entriesJson = json.encode(
      entries.map((entry) => entry.toJson()).toList(),
    );
    await _prefs.setString(_woopEntriesKey, entriesJson);
  }

  // Export all entries as JSON string (for backup/sharing)
  Future<String> exportEntries() async {
    final entries = await getAllWoopEntries();
    return json.encode(entries.map((e) => e.toJson()).toList());
  }

  // Import entries from JSON string (for restore/sharing)
  Future<void> importEntries(String jsonString, {bool clearExisting = false}) async {
    _ensureInitialized();
    
    try {
      final List<dynamic> importedData = json.decode(jsonString);
      final importedEntries = importedData
          .map((entryJson) => WoopEntry.fromJson(entryJson))
          .toList();
      
      List<WoopEntry> finalEntries;
      
      if (clearExisting) {
        finalEntries = importedEntries;
      } else {
        final existingEntries = await getAllWoopEntries();
        
        // Merge entries, avoiding duplicates by ID
        final Map<String, WoopEntry> entryMap = {
          for (var entry in existingEntries) entry.id: entry
        };
        
        for (var importedEntry in importedEntries) {
          entryMap[importedEntry.id] = importedEntry;
        }
        
        finalEntries = entryMap.values.toList();
      }
      
      // Sort by creation date
      finalEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      await _saveEntriesToStorage(finalEntries);
    } catch (e) {
      throw FormatException('Invalid import data format: $e');
    }
  }
}