import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/services/result_file_handler_service.dart';
import 'package:radiology_and_lab_app/features/results/domain/entites/result_entity.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_cubit.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_state.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class PatientResultsScreen extends StatefulWidget {
  final bool showBackButton;
  const PatientResultsScreen({super.key, this.showBackButton = false});

  @override
  State<PatientResultsScreen> createState() => _PatientResultsScreenState();
}

class _PatientResultsScreenState extends State<PatientResultsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Radiology', 'Laboratory'];

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<ResultsCubit>().getPatientResults(uid);
    }
  }

  List<ResultEntity> _applyFilter(List<ResultEntity> results) {
    if (_selectedFilter == 'All') return results;
    return results
        .where(
          (r) => r.department.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              )
            : null,
        title: const Text(
          'My Results',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ── Filter Bar ───────────────────────────────────────────────────
          Container(
            height: 56,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: const Color(0xFF1F2937),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          Expanded(
            child: BlocConsumer<ResultsCubit, ResultsState>(
              listener: (context, state) {
                if (state is ResultsError) {
                  AppSnackBar.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is ResultsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ResultsLoaded) {
                  final filtered = _applyFilter(state.results);

                  if (filtered.isEmpty) {
                    return _EmptyResults();
                  }

                  final reviewed =
                      filtered.where((r) => r.reviewedByDoctor).length;
                  final pending =
                      filtered.where((r) => !r.reviewedByDoctor).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        child: Row(
                          children: [
                            Text(
                              '${filtered.length} results',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (reviewed > 0)
                              _StatBadge(
                                label: '$reviewed Ready',
                                color: const Color(0xFF0D9488),
                              ),
                            if (pending > 0)
                              _StatBadge(
                                label: '$pending Processing',
                                color: const Color(0xFFF59E0B),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _ResultCard(result: filtered[index]);
                          },
                        ),
                      ),
                    ],
                  );
                }

                return _EmptyResults();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Result Card ───────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final ResultEntity result;

  const _ResultCard({required this.result});

  Color _classificationColor() {
    switch (result.classification?.toLowerCase()) {
      case 'normal':
        return const Color(0xFF0D9488);
      case 'abnormal':
        return const Color(0xFFF59E0B);
      case 'critical':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReviewed = result.reviewedByDoctor;
    final isRadiology = result.department.toLowerCase() == 'radiology';
    final accentColor =
        isRadiology ? const Color(0xFF0D9488) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: accentColor, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ResultFileHandlerService.getColorForFile(result.resultFileUrl).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              ResultFileHandlerService.getIconForFile(result.resultFileUrl),
                              color: ResultFileHandlerService.getColorForFile(result.resultFileUrl),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.testType.isNotEmpty
                                      ? result.testType
                                      : result.department,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  _formatDate(result.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status badge
                          _StatusBadge(
                            isReviewed: isReviewed,
                            classification: result.classification,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // If not reviewed — show pending message
                      if (!isReviewed) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.hourglass_top_outlined,
                                size: 14,
                                color: Color(0xFFF59E0B),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Pending Doctor Review',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF92400E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Classification + review date
                        if (result.classification != null)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _classificationColor().withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  result.classification!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _classificationColor(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (result.reviewedAt != null)
                                Text(
                                  'Reviewed ${_formatDate(result.reviewedAt!)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                            ],
                          ),

                        if (result.doctorNotes != null &&
                            result.doctorNotes!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            result.doctorNotes!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Reviewed by + action buttons
                        if (result.reviewedBy != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                size: 13,
                                color: Color(0xFF0D9488),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reviewed by Dr. ${result.reviewedBy}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ResultFileHandlerService.previewFile(context, result.resultFileUrl),
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 14,
                                ),
                                label: const Text(
                                  'Preview',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF374151),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => ResultFileHandlerService.openOrDownloadFile(context, result.resultFileUrl),
                                icon: const Icon(
                                  Icons.download_outlined,
                                  size: 14,
                                ),
                                label: const Text(
                                  'Download',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isReviewed;
  final String? classification;

  const _StatusBadge({required this.isReviewed, this.classification});

  @override
  Widget build(BuildContext context) {
    if (!isReviewed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'PROCESSING',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD97706),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'COMPLETED',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFF065F46),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'No results yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your test results will appear here\nonce uploaded by the lab.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
