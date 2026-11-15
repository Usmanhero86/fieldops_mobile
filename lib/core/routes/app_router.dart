import 'package:flutter/material.dart';
import '../../features/actitivies/presentation/screens/field_activity_page.dart';
import '../../features/admin/presentation/shell/admin_shell.dart';
import '../../features/beneficiaries/presentation/screens/beneficiary_registration_page.dart';
import '../../features/communities/presentation/screens/communities_page.dart';
import '../../features/communities/presentation/screens/community_registration_page.dart';
import '../../features/presentation/screens/login_screen.dart';
import '../../features/presentation/screens/splash_screen.dart';
import '../../features/reports/presentation/screens/reports_page.dart';
import '../../features/shell/app_shell.dart';
import '../widgets/deferred_screen.dart';

class AppRouter {
  AppRouter._();

  // ─────────────────────────────────────────────────────────────────────────
  // Route name constants
  // ─────────────────────────────────────────────────────────────────────────

  static const String splash = '/';
  static const String login = '/login';
  static const String shell = '/shell';

  // Shell tab shortcuts
  // Release 1 tabs: 0=Home  1=Projects  2=Activities  3=Profile
  static const String dashboard = '/dashboard';
  static const String projects = '/projects';
  static const String activities = '/activities';
  static const String profile = '/profile';
  static const String more = '/more'; // legacy alias → profile tab

  // Release 1 full-screen pushes
  static const String beneficiaries = '/beneficiaries';
  static const String beneficiaryRegister = '/beneficiaries/register';
  static const String activityLog = '/activities/log';
  static const String communities = '/communities';
  static const String communityRegister = '/communities/register';

  // Release 2 (deferred)
  static const String pendingSync = '/pending-sync';
  static const String mapRoute = '/map';

  // Release 3 (deferred)
  static const String reports = '/reports';

  // Admin / Supervisor shell
  static const String adminShell = '/admin';

  // ─────────────────────────────────────────────────────────────────────────
  // Route generation
  // ─────────────────────────────────────────────────────────────────────────

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Entry ─────────────────────────────────────────────────────────────
      case splash:
        return _fade(const SplashScreen());
      case login:
        return _fade(const LoginScreen());

      // ── Shell tabs ─────────────────────────────────────────────────────────
      case shell:
      case dashboard:
        return _fade(const AppShell(initialIndex: 0));
      case projects:
        return _fade(const AppShell(initialIndex: 1));
      case activities:
        return _fade(const AppShell(initialIndex: 2));
      case profile:
      case more:
        return _fade(const AppShell(initialIndex: 3));

      // ── Release 1: full-screen pages ──────────────────────────────────────
      // Beneficiary list is reached from Community Detail inside the shell;
      // a direct push of /beneficiaries just opens the shell on the Home tab.
      case beneficiaries:
        return _fade(const AppShell(initialIndex: 0));

      case beneficiaryRegister:
        return MaterialPageRoute(
          builder: (_) => const BeneficiaryRegistrationPage(),
          fullscreenDialog: true,
        );

      case activityLog:
        return MaterialPageRoute(
          builder: (_) => const FieldActivityPage(),
          fullscreenDialog: true,
        );

      case communities:
        return MaterialPageRoute(builder: (_) => const CommunitiesPage());

      case communityRegister:
        return MaterialPageRoute(
          builder: (_) => const CommunityRegistrationPage(),
          fullscreenDialog: true,
        );

      // ── Release 2 (deferred) ───────────────────────────────────────────────
      case pendingSync:
        return MaterialPageRoute(
          builder: (_) => const DeferredScreen(
            release: 2,
            label: 'Sync Center',
            icon: Icons.cloud_sync_outlined,
          ),
        );
      case mapRoute:
        return MaterialPageRoute(
          builder: (_) => const DeferredScreen(
            release: 2,
            label: 'Map',
            icon: Icons.map_outlined,
          ),
        );

      // ── Release 3 ──────────────────────────────────────────────────────────
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsPage());

      // ── Admin / Supervisor ─────────────────────────────────────────────────
      case adminShell:
        return _fade(const AdminShell());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }

  static PageRouteBuilder<dynamic> _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, a1, a2) => page,
      transitionsBuilder: (context, animation, a2, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 220),
    );
  }
}
