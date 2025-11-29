import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/route/app_router.gr.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/presentation/cubit/inspection_list_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_loading.dart';

@RoutePage()
class InspectionListPage extends StatelessWidget {
  const InspectionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InspectionListCubit>()..loadInspections(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inspections'),
        ),
        body: BlocBuilder<InspectionListCubit, BaseState<List<InspectionEntity>>>(
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
                      state.errorMessage ?? 'Failed to load inspections',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<InspectionListCubit>().loadInspections(),
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
                    Icon(Icons.checklist, size: 64, color: AppColor.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No inspections yet',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            final inspections = state.data ?? [];
            return RefreshIndicator(
              onRefresh: () => context.read<InspectionListCubit>().refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: inspections.length,
                itemBuilder: (context, index) {
                  final inspection = inspections[index];
                  return _InspectionCard(
                    inspection: inspection,
                    onTap: () => context.router.push(
                      InspectionFormRoute(inspectionId: inspection.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Show template selection dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Template selection coming soon')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  final InspectionEntity inspection;
  final VoidCallback onTap;

  const _InspectionCard({
    required this.inspection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(inspection.status)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      inspection.status.name.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: _getStatusColor(inspection.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    inspection.category,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                inspection.title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (inspection.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  inspection.description!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${inspection.completedItems}/${inspection.totalItems} items',
                        style: AppTypography.labelSmall,
                      ),
                      Text(
                        '${inspection.completionPercentage.toStringAsFixed(0)}%',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: inspection.completionPercentage / 100,
                    backgroundColor: AppColor.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(inspection.status),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.pending:
        return AppColor.warning;
      case InspectionStatus.inProgress:
        return AppColor.info;
      case InspectionStatus.completed:
        return AppColor.success;
      case InspectionStatus.failed:
        return AppColor.error;
    }
  }
}

