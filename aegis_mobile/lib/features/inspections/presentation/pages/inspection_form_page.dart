import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/presentation/cubit/inspection_form_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_button.dart';

@RoutePage()
class InspectionFormPage extends StatelessWidget {
  final String inspectionId;

  const InspectionFormPage({
    super.key,
    @PathParam('id') required this.inspectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InspectionFormCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inspection Checklist'),
          actions: [
            BlocBuilder<InspectionFormCubit, BaseState<InspectionEntity>>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      '${context.read<InspectionFormCubit>().progress.toStringAsFixed(0)}%',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<InspectionFormCubit, BaseState<InspectionEntity>>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isError) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to load inspection'),
              );
            }

            final inspection = state.data;
            if (inspection == null) {
              return const Center(child: Text('Inspection not found'));
            }

            return Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: inspection.completionPercentage / 100,
                  backgroundColor: AppColor.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: inspection.checklistItems.length,
                    itemBuilder: (context, index) {
                      final item = inspection.checklistItems[index];
                      return _ChecklistItemCard(
                        item: item,
                        index: index + 1,
                        onCompliantChanged: (value) {
                          context
                              .read<InspectionFormCubit>()
                              .updateChecklistItem(item.id, isCompliant: value);
                        },
                        onNotesChanged: (notes) {
                          context
                              .read<InspectionFormCubit>()
                              .updateChecklistItem(item.id, notes: notes);
                        },
                      );
                    },
                  ),
                ),
                // Submit button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    text: 'Submit Inspection',
                    onPressed: context.read<InspectionFormCubit>().isComplete
                        ? () => _showSubmitDialog(context)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit Inspection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to submit this inspection?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InspectionFormCubit>().submitInspection(
                    notes: notesController.text.isNotEmpty
                        ? notesController.text
                        : null,
                  );
              context.router.maybePop();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItemCard extends StatefulWidget {
  final ChecklistItemEntity item;
  final int index;
  final ValueChanged<bool> onCompliantChanged;
  final ValueChanged<String> onNotesChanged;

  const _ChecklistItemCard({
    required this.item,
    required this.index,
    required this.onCompliantChanged,
    required this.onNotesChanged,
  });

  @override
  State<_ChecklistItemCard> createState() => _ChecklistItemCardState();
}

class _ChecklistItemCardState extends State<_ChecklistItemCard> {
  bool _isExpanded = false;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.item.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(),
              child: Text(
                '${widget.index}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.item.question,
              style: AppTypography.bodyMedium,
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compliance buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ComplianceButton(
                          label: 'Compliant',
                          icon: Icons.check_circle,
                          isSelected: widget.item.isCompliant == true,
                          color: AppColor.success,
                          onTap: () => widget.onCompliantChanged(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ComplianceButton(
                          label: 'Non-Compliant',
                          icon: Icons.cancel,
                          isSelected: widget.item.isCompliant == false,
                          color: AppColor.error,
                          onTap: () => widget.onCompliantChanged(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Notes field
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                      hintText: 'Add notes or observations...',
                    ),
                    maxLines: 2,
                    onChanged: widget.onNotesChanged,
                  ),
                  const SizedBox(height: 12),
                  // Add photo button
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement photo capture
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Photo capture coming soon')),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Add Photo'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (widget.item.isCompliant == null) {
      return AppColor.grey;
    }
    return widget.item.isCompliant! ? AppColor.success : AppColor.error;
  }
}

class _ComplianceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ComplianceButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : AppColor.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColor.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? color : AppColor.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

