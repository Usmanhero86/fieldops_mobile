import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // only needed by FAB haptics
// import '../../core/routes/app_router.dart'; // only needed by FAB navigation
import '../../core/themes/app_colors.dart';
import '../actitivies/presentation/screens/activity_list_page.dart';
import '../dashboard/presentation/screens/dashboard_page.dart';
import '../profile/presentation/screens/profile_page.dart';
import '../projects/presentation/screens/projects_page.dart';

/// Persistent bottom-navigation shell — UI Release 1.
///
/// Tabs: Home | Projects | Activities | Profile
///
/// NOTE: The expandable FAB (Register Beneficiary · Log Activity) has been
/// commented out because both actions are already accessible from the
/// Quick Actions section on the dashboard, avoiding duplication.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late int _index;
  // FAB commented out — Quick Actions on the dashboard cover both actions.
  // bool _fabOpen = false;
  // late final AnimationController _fabController;
  // late final Animation<double> _fabScale;
  // late final Animation<double> _fabRotate;

  // Release 1 tabs: 0=Home  1=Projects  2=Activities  3=Profile
  static const _pages = <Widget>[
    DashboardPage(),
    ProjectsPage(),
    ActivityListPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    // _fabController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 220),
    // );
    // _fabScale = CurvedAnimation(
    //   parent: _fabController,
    //   curve: Curves.easeOutBack,
    // );
    // _fabRotate = Tween<double>(
    //   begin: 0,
    //   end: 0.125,
    // ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // _fabController.dispose();
    super.dispose();
  }

  // void _toggleFab() {
  //   HapticFeedback.lightImpact();
  //   setState(() => _fabOpen = !_fabOpen);
  //   if (_fabOpen) {
  //     _fabController.forward();
  //   } else {
  //     _fabController.reverse();
  //   }
  // }

  // void _closeFab() {
  //   if (_fabOpen) {
  //     setState(() => _fabOpen = false);
  //     _fabController.reverse();
  //   }
  // }

  // void _navigateTo(String route) {
  //   _closeFab();
  //   Navigator.pushNamed(context, route);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
      // floatingActionButton: _ExpandableFab(
      //   isOpen: _fabOpen,
      //   scaleAnim: _fabScale,
      //   rotateAnim: _fabRotate,
      //   onToggle: _toggleFab,
      //   onRegister: () => _navigateTo(AppRouter.beneficiaryRegister),
      //   onLogActivity: () => _navigateTo(AppRouter.activityLog),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ---------------------------------------------------------------------------
// Expandable FAB — commented out; Quick Actions on the dashboard cover both
// Register Beneficiary and Log Activity. Uncomment to restore.
// ---------------------------------------------------------------------------

// class _ExpandableFab extends StatelessWidget {
//   const _ExpandableFab({
//     required this.isOpen,
//     required this.scaleAnim,
//     required this.rotateAnim,
//     required this.onToggle,
//     required this.onRegister,
//     required this.onLogActivity,
//   });
//
//   final bool isOpen;
//   final Animation<double> scaleAnim;
//   final Animation<double> rotateAnim;
//   final VoidCallback onToggle;
//   final VoidCallback onRegister;
//   final VoidCallback onLogActivity;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ScaleTransition(
//             scale: scaleAnim,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _FabAction(
//                   icon: Icons.person_add_outlined,
//                   label: 'Register Beneficiary',
//                   color: AppColors.primary,
//                   onTap: onRegister,
//                 ),
//                 const SizedBox(height: 8),
//                 _FabAction(
//                   icon: Icons.add_chart_outlined,
//                   label: 'Log Activity',
//                   color: AppColors.success,
//                   onTap: onLogActivity,
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ),
//           ),
//           RotationTransition(
//             turns: rotateAnim,
//             child: FloatingActionButton(
//               onPressed: onToggle,
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               elevation: 4,
//               heroTag: null,
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: isOpen
//                     ? const Icon(Icons.close, key: ValueKey('close'))
//                     : const Icon(Icons.add, key: ValueKey('add'), size: 28),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FabAction extends StatelessWidget {
//   const _FabAction({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.12),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withValues(alpha: 0.35),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 20),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------
// Bottom navigation bar — Release 1: Home | Projects | [FAB] | Activities | Profile
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                active: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.folder_open_outlined,
                activeIcon: Icons.folder_open,
                label: 'Projects',
                active: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              // Centre spacer removed — FAB is commented out.
              _NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: 'Activities',
                active: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                active: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  active ? activeIcon : icon,
                  key: ValueKey(active),
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
