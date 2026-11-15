import 'package:flutter/material.dart';
import 'admin_reports_page.dart';

/// Admin: all field activities from all officers, sorted newest first.
/// Tapping opens the existing AdminReportsPage which already has
/// full filter + detail support — so we simply push that.
///
/// This page itself is a lightweight redirect.
class AdminActivitiesOverviewPage extends StatelessWidget {
  const AdminActivitiesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the full reports page which already shows all activities
    // with officer filter, type filter, and detail cards.
    return const AdminReportsPage();
  }
}
