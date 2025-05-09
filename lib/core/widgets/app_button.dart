import 'package:dubts/core/theme/app_colors.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(context);
      case ButtonType.secondary:
        return _buildSecondaryButton(context);
      case ButtonType.outline:
        return _buildOutlinedButton(context);
      case ButtonType.text:
        return _buildTextButton(context);
    }
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: padding ?? _getPadding(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: padding ?? _getPadding(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        padding: padding ?? _getPadding(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
        ),
        side: const BorderSide(color: Colors.black12),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: padding ?? _getPadding(context),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(context),
        width: _getIconSize(context),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary ? Colors.white : AppColors.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize(context)),
          if (text.isNotEmpty) SizedBox(width: ResponsiveUtils.getProportionateScreenWidth(context, 8)),
          if (text.isNotEmpty) Text(text, style: _getTextStyle(context)),
        ],
      );
    }

    return Text(text, style: _getTextStyle(context));
  }

  EdgeInsets _getPadding(BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 16),
          vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
        );
      case ButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 24),
          vertical: ResponsiveUtils.getProportionateScreenHeight(context, 12),
        );
      case ButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 32),
          vertical: ResponsiveUtils.getProportionateScreenHeight(context, 16),
        );
    }
  }

  double _getIconSize(BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return ResponsiveUtils.getProportionateScreenWidth(context, 16);
      case ButtonSize.medium:
        return ResponsiveUtils.getProportionateScreenWidth(context, 20);
      case ButtonSize.large:
        return ResponsiveUtils.getProportionateScreenWidth(context, 24);
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return TextStyle(fontSize: ResponsiveUtils.getProportionateScreenWidth(context, 12));
      case ButtonSize.medium:
        return TextStyle(fontSize: ResponsiveUtils.getProportionateScreenWidth(context, 14));
      case ButtonSize.large:
        return TextStyle(fontSize: ResponsiveUtils.getProportionateScreenWidth(context, 16));
    }
  }
}