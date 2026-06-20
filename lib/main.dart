import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_config.dart';
import 'services/firebase_config.dart';
import 'providers/dashboard_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';
import 'ui/screens/auth_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    ),
    FirebaseConfig.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = DashboardProvider();
            provider.init();
            return provider;
          },
        ),
      ],
      child: const AkibaFlowApp(),
    ),
  );
}

class AkibaFlowApp extends StatelessWidget {
  const AkibaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Akiba Flow',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: prov.isDark ? ThemeMode.dark : ThemeMode.light,
          home: _AuthGate(),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, DashboardProvider>(
      builder: (context, auth, prov, _) {
        if (!auth.isSignedIn) {
          return AuthScreen(onSignIn: () {});
        }

        if (!prov.hasLoaded || prov.loadingProfile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            prov.init();
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!prov.isOnboarded) {
          return const OnboardingScreen();
        }

        return const DashboardScreen();
      },
    );
  }
}
