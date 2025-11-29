import 'package:flutter/material.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  factory AppHeader.transparent({
    Key? key,
    String? title,
    Widget? titleWidget,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    Widget? leading,
    Color? foregroundColor,
  }) {
    return AppHeader(
      key: key,
      title: title,
      titleWidget: titleWidget,
      centerTitle: centerTitle,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      actions: actions,
      leading: leading,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      elevation: 0,
    );
  }

  factory AppHeader.primary({
    Key? key,
    String? title,
    Widget? titleWidget,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    Widget? leading,
    PreferredSizeWidget? bottom,
  }) {
    return AppHeader(
      key: key,
      title: title,
      titleWidget: titleWidget,
      centerTitle: centerTitle,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      actions: actions,
      leading: leading,
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.white,
      elevation: 0,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null
          ? Text(
              title!,
              style: AppTypography.titleLarge.copyWith(
                color: foregroundColor ?? AppColor.textPrimary,
              ),
            )
          : null),
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: backgroundColor ?? AppColor.white,
      foregroundColor: foregroundColor ?? AppColor.textPrimary,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: foregroundColor ?? AppColor.textPrimary,
          size: 20,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return null;
  }
}

class AppSliverHeader extends StatelessWidget {
  final String title;
  final String? expandedTitle;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final Widget? flexibleSpace;
  final Widget? background;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppSliverHeader({
    super.key,
    required this.title,
    this.expandedTitle,
    this.expandedHeight = 200,
    this.pinned = true,
    this.floating = false,
    this.flexibleSpace,
    this.background,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      backgroundColor: backgroundColor ?? AppColor.white,
      foregroundColor: foregroundColor ?? AppColor.textPrimary,
      surfaceTintColor: Colors.transparent,
      leading: _buildLeading(context),
      actions: actions,
      flexibleSpace: flexibleSpace ??
          FlexibleSpaceBar(
            title: Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: foregroundColor ?? AppColor.textPrimary,
              ),
            ),
            centerTitle: true,
            background: background,
            collapseMode: CollapseMode.parallax,
          ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: foregroundColor ?? AppColor.textPrimary,
          size: 20,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    return null;
  }
}

class AppBottomBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final BottomNavigationBarType? type;

  const AppBottomBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor ?? AppColor.white,
      selectedItemColor: selectedItemColor ?? AppColor.primary,
      unselectedItemColor: unselectedItemColor ?? AppColor.gray500,
      type: type ?? BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
      elevation: 8,
    );
  }
}

