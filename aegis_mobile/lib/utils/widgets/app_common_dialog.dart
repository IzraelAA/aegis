import 'package:flutter/material.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_button.dart';

enum DialogType { info, success, warning, error, confirm }

class AppCommonDialog {
  AppCommonDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    DialogType type = DialogType.info,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    bool showCloseButton = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _DialogContent(
        title: title,
        message: message,
        content: content,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      message: message,
      type: isDanger ? DialogType.warning : DialogType.confirm,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      barrierDismissible: false,
    );
  }

  static Future<void> success({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
      confirmText: buttonText,
      onConfirm: onPressed,
    );
  }

  static Future<void> error({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      confirmText: buttonText,
      onConfirm: onPressed,
    );
  }

  static Future<void> warning({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.warning,
      confirmText: buttonText,
      onConfirm: onPressed,
    );
  }

  static Future<void> info({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.info,
      confirmText: buttonText,
      onConfirm: onPressed,
    );
  }
}

class _DialogContent extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final DialogType type;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCloseButton;

  const _DialogContent({
    required this.title,
    this.message,
    this.content,
    required this.type,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: AppColor.gray500,
                    size: 24,
                  ),
                ),
              ),
            _buildIcon(),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColor.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],
            const SizedBox(height: 24),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (type) {
      case DialogType.info:
        icon = Icons.info_outline;
        color = AppColor.info;
        backgroundColor = AppColor.infoLight;
        break;
      case DialogType.success:
        icon = Icons.check_circle_outline;
        color = AppColor.success;
        backgroundColor = AppColor.successLight;
        break;
      case DialogType.warning:
        icon = Icons.warning_amber_outlined;
        color = AppColor.warning;
        backgroundColor = AppColor.warningLight;
        break;
      case DialogType.error:
        icon = Icons.error_outline;
        color = AppColor.error;
        backgroundColor = AppColor.errorLight;
        break;
      case DialogType.confirm:
        icon = Icons.help_outline;
        color = AppColor.primary;
        backgroundColor = AppColor.primarySurface;
        break;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final bool showCancelButton = 
        type == DialogType.confirm || cancelText != null;

    if (showCancelButton) {
      return Row(
        children: [
          Expanded(
            child: AppButton.outline(
              text: cancelText ?? 'Cancel',
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: type == DialogType.warning
                ? AppButton.danger(
                    text: confirmText ?? 'Confirm',
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                  )
                : AppButton.primary(
                    text: confirmText ?? 'Confirm',
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                  ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: AppButton.primary(
        text: confirmText ?? 'OK',
        onPressed: () {
          Navigator.of(context).pop();
          onConfirm?.call();
        },
      ),
    );
  }
}

