import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../models/appointment_model.dart';

/// Dark teal appointment card matching the Figma design.
/// Shows date, time, scan name, doctor, and a "Confirmed" badge.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.apptCardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330F766E),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative dark arc on the left
            Positioned(
              left: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.apptCardDark,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date + Time column
                  FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appointment.date, style: AppTypography.apptDate),
                        const SizedBox(height: 2),
                        Text('12:39', style: AppTypography.apptTime),
                        Text(appointment.amPm, style: AppTypography.apptAmPm),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Divider
                  Container(
                    width: 1,
                    height: 72,
                    color: AppColors.glassWhiteBorder,
                  ),
                  const SizedBox(width: 16),

                  // Title + doctor column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            appointment.title,
                            style: AppTypography.apptTitle,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.headerSubtitle,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.doctorName,
                              style: AppTypography.apptDoctor,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        if (appointment.isConfirmed)
                          Align(
                            alignment: Alignment.topRight,
                            child: _ConfirmedBadge(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.apptConfirmedBadge.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.apptConfirmedBadge.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.textWhite,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            AppStrings.apptConfirmed,
            style: AppTypography.apptConfirmedBadge,
          ),
        ],
      ),
    );
  }
}
