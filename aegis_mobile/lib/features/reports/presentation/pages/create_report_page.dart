import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/presentation/cubit/create_report_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_button.dart';
import 'package:aegis_mobile/utils/widgets/app_text_form_field.dart';
import 'package:aegis_mobile/utils/validators/form_validators.dart';

@RoutePage()
class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  ReportSeverity _selectedSeverity = ReportSeverity.medium;
  double? _latitude;
  double? _longitude;
  final List<String> _photoUrls = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSubmit(CreateReportCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      final report = ReportEntity(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _selectedSeverity,
        status: ReportStatus.pending,
        latitude: _latitude,
        longitude: _longitude,
        locationName: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        photoUrls: _photoUrls,
        createdAt: DateTime.now(),
      );
      cubit.createReport(report);
    }
  }

  Future<void> _getCurrentLocation() async {
    // TODO: Implement actual location fetching using geolocator
    // For now, using placeholder
    setState(() {
      _latitude = 0.0;
      _longitude = 0.0;
      _locationController.text = 'Current Location';
    });
  }

  Future<void> _addPhoto() async {
    // TODO: Implement photo picking using image_picker
    // For now, showing placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo picker will be implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateReportCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Report'),
        ),
        body: BlocConsumer<CreateReportCubit, BaseState<ReportEntity>>(
          listener: (context, state) {
            if (state.isSuccess) {
              final isOffline = state.data?.isOffline ?? false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isOffline
                        ? 'Report saved offline. Will sync when online.'
                        : 'Report created successfully',
                  ),
                  backgroundColor:
                      isOffline ? AppColor.warning : AppColor.success,
                ),
              );
              context.router.maybePop();
            } else if (state.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to create report'),
                  backgroundColor: AppColor.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    AppTextFormField(
                      controller: _titleController,
                      label: 'Title',
                      hint: 'Enter report title',
                      validator: FormValidators.required,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    AppTextFormField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Describe the incident in detail',
                      maxLines: 5,
                      validator: FormValidators.required,
                    ),
                    const SizedBox(height: 16),

                    // Severity
                    Text(
                      'Severity',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ReportSeverity.values.map((severity) {
                        final isSelected = _selectedSeverity == severity;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSeverity = severity;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _getSeverityColor(severity)
                                    : AppColor.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? _getSeverityColor(severity)
                                      : AppColor.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                severity.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: AppTypography.labelSmall.copyWith(
                                  color: isSelected
                                      ? AppColor.white
                                      : AppColor.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            controller: _locationController,
                            label: 'Location',
                            hint: 'Enter location name',
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.my_location),
                          color: AppColor.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Photos
                    Text(
                      'Photos',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _addPhoto,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColor.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_photoUrls.isNotEmpty)
                          Expanded(
                            child: SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _photoUrls.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(_photoUrls[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    AppButton(
                      text: 'Submit Report',
                      onPressed: () => _onSubmit(context.read<CreateReportCubit>()),
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
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
}

