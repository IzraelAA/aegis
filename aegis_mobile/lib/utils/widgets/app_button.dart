import 'package:flutter/material.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.borderRadius = 12,
  });

  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.primary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outline,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
    );
  }

  factory AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.text,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
    );
  }

  factory AppButton.danger({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.danger,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: _getHeight(),
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final buttonStyle = _getButtonStyle();
    final child = _buildChild();

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: _isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: _getTextStyle(),
    );

    if (prefixIcon == null && suffixIcon == null) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _getIconSize()),
          SizedBox(width: _getIconSpacing()),
        ],
        textWidget,
        if (suffixIcon != null) ...[
          SizedBox(width: _getIconSpacing()),
          Icon(suffixIcon, size: _getIconSize()),
        ],
      ],
    );
  }

  bool get _isEnabled => !isDisabled && !isLoading;

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case AppButtonSize.small:
        return 6;
      case AppButtonSize.medium:
        return 8;
      case AppButtonSize.large:
        return 10;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall.copyWith(color: _getTextColor());
      case AppButtonSize.medium:
        return AppTypography.buttonMedium.copyWith(color: _getTextColor());
      case AppButtonSize.large:
        return AppTypography.buttonLarge.copyWith(color: _getTextColor());
    }
  }

  Color _getTextColor() {
    if (!_isEnabled) {
      return AppColor.textDisabled;
    }

    switch (type) {
      case AppButtonType.primary:
        return AppColor.white;
      case AppButtonType.secondary:
        return AppColor.primary;
      case AppButtonType.outline:
        return AppColor.primary;
      case AppButtonType.text:
        return AppColor.primary;
      case AppButtonType.danger:
        return AppColor.white;
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return AppColor.white;
      case AppButtonType.secondary:
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColor.primary;
    }
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          disabledBackgroundColor: AppColor.gray200,
          disabledForegroundColor: AppColor.textDisabled,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColor.primarySurface,
          foregroundColor: AppColor.primary,
          disabledBackgroundColor: AppColor.gray100,
          disabledForegroundColor: AppColor.textDisabled,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColor.primary,
          disabledForegroundColor: AppColor.textDisabled,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: _isEnabled ? AppColor.primary : AppColor.border,
          ),
        );
      case AppButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: AppColor.primary,
          disabledForegroundColor: AppColor.textDisabled,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColor.error,
          foregroundColor: AppColor.white,
          disabledBackgroundColor: AppColor.gray200,
          disabledForegroundColor: AppColor.textDisabled,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        );
    }
  }
}

