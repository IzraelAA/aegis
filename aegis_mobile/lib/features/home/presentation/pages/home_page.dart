import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:aegis_mobile/core/route/app_router.gr.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aegis Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.router.push(const NotificationListRoute()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome back!',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'What would you like to do today?',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColor.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _QuickActionCard(
                  icon: Icons.report_problem,
                  title: 'Report Incident',
                  subtitle: 'Submit new report',
                  color: AppColor.error,
                  onTap: () => context.router.push(const CreateReportRoute()),
                ),
                _QuickActionCard(
                  icon: Icons.checklist,
                  title: 'Inspections',
                  subtitle: 'View checklists',
                  color: AppColor.success,
                  onTap: () => context.router.push(const InspectionListRoute()),
                ),
                _QuickActionCard(
                  icon: Icons.description,
                  title: 'My Reports',
                  subtitle: 'View all reports',
                  color: AppColor.warning,
                  onTap: () => context.router.push(const ReportListRoute()),
                ),
                _QuickActionCard(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Account settings',
                  color: AppColor.info,
                  onTap: () => context.router.push(const ProfileRoute()),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.router.push(const ReportListRoute()),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Recent Activity List (Placeholder)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.warning.withValues(alpha: 0.2),
                  child: Icon(Icons.warning, color: AppColor.warning, size: 20),
                ),
                title: const Text('Safety Inspection Due'),
                subtitle: const Text('Due in 2 days'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.router.push(const InspectionListRoute()),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.success.withValues(alpha: 0.2),
                  child: Icon(Icons.check_circle, color: AppColor.success, size: 20),
                ),
                title: const Text('Report Submitted'),
                subtitle: const Text('Equipment malfunction - Today'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.router.push(const ReportListRoute()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.router.push(const ReportListRoute());
              break;
            case 2:
              context.router.push(const InspectionListRoute());
              break;
            case 3:
              context.router.push(const ProfileRoute());
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Inspections',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
