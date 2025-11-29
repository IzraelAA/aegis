import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';

class AppTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsets? contentPadding;
  final double borderRadius;
  final bool showPasswordToggle;

  const AppTextFormField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode,
    this.contentPadding,
    this.borderRadius = 12,
    this.showPasswordToggle = false,
  });

  factory AppTextFormField.password({
    Key? key,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return AppTextFormField(
      key: key,
      label: label,
      hint: hint ?? 'Enter password',
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: true,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      autovalidateMode: autovalidateMode,
      showPasswordToggle: true,
    );
  }

  factory AppTextFormField.email({
    Key? key,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return AppTextFormField(
      key: key,
      label: label,
      hint: hint ?? 'Enter email address',
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator ?? _emailValidator,
      autovalidateMode: autovalidateMode,
    );
  }

  factory AppTextFormField.phone({
    Key? key,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return AppTextFormField(
      key: key,
      label: label,
      hint: hint ?? 'Enter phone number',
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      autovalidateMode: autovalidateMode,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  factory AppTextFormField.multiline({
    Key? key,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool enabled = true,
    int maxLines = 5,
    int minLines = 3,
    int? maxLength,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return AppTextFormField(
      key: key,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
    );
  }

  static String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: widget.enabled
                  ? AppColor.textPrimary
                  : AppColor.textDisabled,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: widget.autovalidateMode,
          style: AppTypography.bodyMedium.copyWith(
            color: widget.enabled
                ? AppColor.textPrimary
                : AppColor.textDisabled,
          ),
          decoration: _buildDecoration(),
        ),
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: AppTypography.caption.copyWith(
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColor.textTertiary,
      ),
      errorText: widget.errorText,
      errorStyle: AppTypography.caption.copyWith(
        color: AppColor.error,
      ),
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      prefixStyle: AppTypography.bodyMedium,
      suffixText: widget.suffixText,
      suffixStyle: AppTypography.bodyMedium,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: widget.enabled ? AppColor.white : AppColor.gray100,
      border: _buildBorder(AppColor.border),
      enabledBorder: _buildBorder(AppColor.border),
      focusedBorder: _buildBorder(AppColor.primary),
      errorBorder: _buildBorder(AppColor.error),
      focusedErrorBorder: _buildBorder(AppColor.error),
      disabledBorder: _buildBorder(AppColor.gray200),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColor.gray500,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

