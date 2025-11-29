import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/route/app_router.gr.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:aegis_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:aegis_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_loading.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Navigate to edit profile
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, BaseState<ProfileEntity>>(
          builder: (context, state) {
            if (state.isLoading) {
              return const AppLoading();
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColor.error),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Failed to load profile',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final profile = state.data;
            if (profile == null) {
              return const Center(child: Text('Profile not found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColor.primary.withValues(alpha: 0.2),
                    backgroundImage: profile.avatar != null
                        ? NetworkImage(profile.avatar!)
                        : null,
                    child: profile.avatar == null
                        ? Text(
                            profile.name.isNotEmpty
                                ? profile.name[0].toUpperCase()
                                : 'U',
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColor.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColor.grey,
                    ),
                  ),
                  if (profile.role != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        profile.role!,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Profile Info
                  _ProfileInfoCard(profile: profile),
                  const SizedBox(height: 24),

                  // Menu Items
                  _MenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Navigate to change password
                    },
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notification Settings',
                    onTap: () {
                      // TODO: Navigate to notification settings
                    },
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      // TODO: Show about dialog
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: AppColor.error,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
              context.router.replaceAll([const LoginRoute()]);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (profile.phone != null)
              _InfoRow(icon: Icons.phone, label: 'Phone', value: profile.phone!),
            if (profile.department != null)
              _InfoRow(
                  icon: Icons.business, label: 'Department', value: profile.department!),
            if (profile.employeeId != null)
              _InfoRow(
                  icon: Icons.badge, label: 'Employee ID', value: profile.employeeId!),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColor.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(color: AppColor.grey),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? AppColor.grey),
        title: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: textColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: textColor ?? AppColor.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}

