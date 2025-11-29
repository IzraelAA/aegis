import 'package:flutter/material.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';

class SampleListTile extends StatelessWidget {
  final SampleEntity sample;
  final VoidCallback? onTap;

  const SampleListTile({
    super.key,
    required this.sample,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColor.primarySurface,
              backgroundImage: sample.avatar != null
                  ? NetworkImage(sample.avatar!)
                  : null,
              child: sample.avatar == null
                  ? Text(
                      sample.name.isNotEmpty ? sample.name[0].toUpperCase() : '?',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColor.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sample.name,
                    style: AppTypography.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sample.email,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColor.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

