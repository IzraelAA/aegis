import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/route/app_router.gr.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/presentation/cubit/report_list_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_loading.dart';

@RoutePage()
class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportListCubit>()..loadReports(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Incident Reports'),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () async {
                final cubit = context.read<ReportListCubit>();
                final count = await cubit.syncOfflineReports();
                if (context.mounted && count > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Synced $count reports')),
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<ReportListCubit, BaseState<List<ReportEntity>>>(
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
                      state.errorMessage ?? 'Failed to load reports',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ReportListCubit>().loadReports(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: AppColor.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No reports yet',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            final reports = state.data ?? [];
            return RefreshIndicator(
              onRefresh: () => context.read<ReportListCubit>().refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _ReportCard(
                    report: report,
                    onTap: () => context.router.push(
                      ReportDetailRoute(reportId: report.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.router.push(const CreateReportRoute()),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback onTap;

  const _ReportCard({
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getSeverityColor(report.severity),
          child: Icon(
            Icons.warning,
            color: AppColor.white,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                report.title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (report.isOffline)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Offline',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.warning,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              report.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(report.createdAt),
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.grey,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Color _getSeverityColor(ReportSeverity severity) {
    switch (severity) {
      case ReportSeverity.low:
        return AppColor.success;
      case ReportSeverity.medium:
        return AppColor.warning;
      case ReportSeverity.high:
        return AppColor.error;
      case ReportSeverity.critical:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

