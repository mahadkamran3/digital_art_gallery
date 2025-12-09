import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/feed/feed_screen.dart';
import 'features/explore/explore_screen.dart';
import 'features/upload/upload_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/auth/login_page.dart';
import 'providers/gallery_provider.dart';
import 'providers/interactions_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final interactionsProvider = InteractionsProvider();
  await interactionsProvider.loadData();

  // Show a user-friendly error screen when a widget build throws an exception.
  // This helps surface the real exception and stack trace in the app UI
  // instead of the app silently failing or the page disappearing.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Also print to console for terminal/devtools visibility
    FlutterError.dumpErrorToConsole(details);
    return Material(
      child: Scaffold(
        appBar: AppBar(title: const Text('Application Error')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            details.exceptionAsString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider.value(value: interactionsProvider),
      ],
      child: const ArtGalleryApp(),
    ),
  );
}

class ArtGalleryApp extends StatelessWidget {
  const ArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Art Gallery',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ).copyWith(
              primary: Colors.blueAccent,
              secondary: Colors.orangeAccent,
              tertiary: Colors.greenAccent,
              surface: Colors.white,
              onSurface: Colors.black87,
              surfaceContainerHighest: Colors.blue.shade50,
            ),
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.blue.shade50,
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ).copyWith(
              primary: Colors.blueAccent,
              secondary: Colors.orangeAccent,
              tertiary: Colors.greenAccent,
              surface: Colors.grey.shade900,
              onSurface: Colors.white,
              surfaceContainerHighest: Colors.grey.shade800,
            ),
        useMaterial3: false,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        cardColor: Colors.grey.shade800,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
      // During development you can set `kDevOpenMain` to `true` to open
      // the main navigation directly (shows the bottom navigation bar).
      // Set to `false` for normal behavior (start at LoginPage).
      home: kDevOpenMain ? const MainNavigation() : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Toggle this to `true` during development to open the app directly
// to the main navigation (useful for testing the bottom bar / explore tab).
const bool kDevOpenMain = false;

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const FeedScreen(),
    const ExploreScreen(),
    const UploadScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.blueAccent),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: Colors.grey),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box, color: Colors.orangeAccent),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.greenAccent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
