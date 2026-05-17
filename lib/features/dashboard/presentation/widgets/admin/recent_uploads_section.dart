import 'package:flutter/material.dart';

import '../shared/empty_state_widget.dart';

/// Placeholder for recently uploaded lab/radiology results.
/// When the upload feature is wired, this will consume a Cubit state.
class RecentUploadsSection extends StatelessWidget {
  const RecentUploadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // MVP: Show empty state until upload feature is connected
    return const EmptyStateWidget(
      message: 'No recent uploads',
      icon: Icons.upload_file_outlined,
    );
  }
}
