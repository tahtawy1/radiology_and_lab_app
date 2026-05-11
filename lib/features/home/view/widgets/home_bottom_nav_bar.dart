import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../models/nav_item_model.dart';

class HomeBottomNavBar extends StatefulWidget {
  const HomeBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onFabTap,
  });

  final List<NavItemModel> items;
  final int selectedIndex;
  final void Function(int index) onItemTap;
  final VoidCallback onFabTap;

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    // Split items around the centre FAB
    final leftItems = widget.items.take(2).toList();
    final rightItems = widget.items.skip(2).toList();
    final leftStart = 0;
    final rightStart = 2;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Nav items
          Row(
            children: [
              // Left items
              ...leftItems.asMap().entries.map(
                (e) => Expanded(
                  child: _NavItem(
                    model: e.value,
                    isActive: widget.selectedIndex == leftStart + e.key,
                    onTap: () {
                      widget.onItemTap(leftStart + e.key);
                      setState(() {});
                    },
                  ),
                ),
              ),

              // FAB placeholder
              const SizedBox(width: 72),

              // Right items
              ...rightItems.asMap().entries.map(
                (e) => Expanded(
                  child: _NavItem(
                    model: e.value,
                    isActive: widget.selectedIndex == rightStart + e.key,
                    onTap: () {
                      widget.onItemTap(rightStart + e.key);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),

          // Centre FAB (floats above bar)
          Positioned(top: -22, child: _CentreActionFab(onTap: widget.onFabTap)),
        ],
      ),
    );
  }
}

/// One navigation item (icon + label).
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.model,
    required this.isActive,
    required this.onTap,
  });

  final NavItemModel model;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.navActive : AppColors.navInactive;
    final double size = isActive ? 28 : 22;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(model.iconData, size: size, color: color),
          Text(
            model.label,
            style: AppTypography.navLabel.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Teal gradient circle FAB centered in the bottom nav.
class _CentreActionFab extends StatelessWidget {
  const _CentreActionFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, AppColors.primary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.textWhite,
          size: 28,
        ),
      ),
    );
  }
}
