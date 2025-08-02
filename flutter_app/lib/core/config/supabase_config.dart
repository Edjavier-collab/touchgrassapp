class SupabaseConfig {
  // These will be loaded from environment variables in web deployment
  // For now, they need to be set manually or through build configuration

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://geaonebvyikhmegjqxpu.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlYW9uZWJ2eWlraG1lZ2pxeHB1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQxMjAwNzIsImV4cCI6MjA2OTY5NjA3Mn0.B6-73DDFhh51EgZC37kRjiXx1EpyhmscnTtDymkqs5w',
  );

  // Validate configuration
  static bool get isConfigured {
    return url.contains('.supabase.co') &&
        anonKey.startsWith('eyJ') &&
        url != 'https://your-project.supabase.co' &&
        anonKey != 'your-anon-key';
  }
}
