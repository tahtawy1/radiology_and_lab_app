import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';

/// Cream-coloured banner showing the patient's current live queue position.
/// Has an orange left accent bar and a pulsing green dot.
class LiveQueueBanner extends StatefulWidget {
  const LiveQueueBanner({
    super.key,
    required this.queueNumber,
    required this.onTap,
  });

  final int queueNumber;
  final VoidCallback onTap;

  @override
  State<LiveQueueBanner> createState() => _LiveQueueBannerState();
}

class _LiveQueueBannerState extends State<LiveQueueBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.queueBannerBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.queueBannerBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Orange left accent
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: AppColors.warningBar,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      // Clock icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.chipOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.chipOrangeIcon,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Live label with pulsing dot
                            Row(
                              children: [
                                FadeTransition(
                                  opacity: _pulse,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: AppColors.queueLiveGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  AppStrings.liveQueue,
                                  style: AppTypography.queueLiveLabel,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${AppStrings.queuePosition}'
                              '${widget.queueNumber}'
                              '${AppStrings.queueInQueue}',
                              style: AppTypography.queueText,
                            ),
                          ],
                        ),
                      ),

                      // Chevron
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
