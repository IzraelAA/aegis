import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/presentation/cubit/report_detail_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_loading.dart';

@RoutePage()
class ReportDetailPage extends StatelessWidget {
  final String reportId;

  const ReportDetailPage({
    super.key,
    @PathParam('id') required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportDetailCubit>()..loadReport(reportId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Report Details'),
        ),
        body: BlocBuilder<ReportDetailCubit, BaseState<ReportEntity>>(
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
                      state.errorMessage ?? 'Failed to load report',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            final report = state.data;
            if (report == null) {
              return const Center(child: Text('Report not found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    report.title,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status & Severity Row
                  Row(
                    children: [
                      _StatusChip(
                        label: report.severity.name.toUpperCase(),
                        color: _getSeverityColor(report.severity),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(
                        label: report.status.name.toUpperCase(),
                        color: _getStatusColor(report.status),
                      ),
                      if (report.isOffline) ...[
                        const SizedBox(width: 8),
                        _StatusChip(
                          label: 'OFFLINE',
                          color: AppColor.warning,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    report.description,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Location
                  if (report.latitude != null && report.longitude != null) ...[
                    _SectionTitle(title: 'Location'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppColor.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (report.locationName != null)
                                  Text(
                                    report.locationName!,
                                    style: AppTypography.bodyMedium,
                                  ),
                                Text(
                                  '${report.latitude}, ${report.longitude}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Photos
                  if (report.photoUrls.isNotEmpty) ...[
                    _SectionTitle(title: 'Photos'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: report.photoUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(report.photoUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reporter Info
                  _SectionTitle(title: 'Reporter'),
                  const SizedBox(height: 8),
                  Text(
                    report.reporterName ?? 'Unknown',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Timestamps
                  _SectionTitle(title: 'Timeline'),
                  const SizedBox(height: 8),
                  Text(
                    'Created: ${_formatDate(report.createdAt)}',
                    style: AppTypography.bodySmall,
                  ),
                  if (report.updatedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Updated: ${_formatDate(report.updatedAt!)}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
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

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.draft:
        return AppColor.grey;
      case ReportStatus.pending:
        return AppColor.warning;
      case ReportStatus.submitted:
        return AppColor.info;
      case ReportStatus.reviewed:
        return AppColor.primary;
      case ReportStatus.resolved:
        return AppColor.success;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

