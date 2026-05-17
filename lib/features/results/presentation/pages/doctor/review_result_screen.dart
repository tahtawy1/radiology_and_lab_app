import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radiology_and_lab_app/core/services/result_file_handler_service.dart';
import 'package:radiology_and_lab_app/features/results/domain/entites/result_entity.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_cubit.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_state.dart';
import 'package:radiology_and_lab_app/features/results/presentation/widgets/doctor/doctor_review_notes.dart';
import 'package:radiology_and_lab_app/features/results/presentation/widgets/doctor/result_classification_selector.dart';
import 'package:radiology_and_lab_app/features/results/presentation/widgets/doctor/review_action_button.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class ReviewResultScreen extends StatefulWidget {
  final ResultEntity result;

  const ReviewResultScreen({super.key, required this.result});

  @override
  State<ReviewResultScreen> createState() => _ReviewResultScreenState();
}

class _ReviewResultScreenState extends State<ReviewResultScreen> {
  final _notesController = TextEditingController();
  String? _selectedClassification;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedClassification == null) {
      AppSnackBar.showError(context, 'Please select a classification.');
      return;
    }
    if (_notesController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please enter medical review notes.');
      return;
    }

    final doctorId = FirebaseAuth.instance.currentUser?.uid ?? '';

    context.read<ResultsCubit>().reviewResult(
          resultId: widget.result.id,
          doctorId: doctorId,
          doctorNotes: _notesController.text.trim(),
          classification: _selectedClassification!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final isRadiology = result.department.toLowerCase() == 'radiology';
    final accentColor =
        isRadiology ? const Color(0xFF0D9488) : const Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Review Result',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<ResultsCubit, ResultsState>(
        listener: (context, state) {
          if (state is ResultsActionSuccess) {
            AppSnackBar.showSuccess(context, state.message);
            context.pop();
          } else if (state is ResultsError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Patient + Test Info Card ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            result.testType.isNotEmpty ? result.testType : result.department,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(result.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Patient ID: ${result.patientId}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Appointment: ${result.appointmentId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Uploaded File Preview ──────────────────────────────────────
              const Text(
                'Uploaded Result File',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ResultFileHandlerService.getColorForFile(result.resultFileUrl).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        ResultFileHandlerService.getIconForFile(result.resultFileUrl),
                        color: ResultFileHandlerService.getColorForFile(result.resultFileUrl),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Result Document',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            result.resultFileUrl,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Color(0xFF0D9488),
                      ),
                      onPressed: () => ResultFileHandlerService.previewFile(context, result.resultFileUrl),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Lab Notes ─────────────────────────────────────────────────
              if (result.notes.isNotEmpty) ...[
                const Text(
                  'Lab / Admin Notes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    result.notes,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF78350F),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Classification ─────────────────────────────────────────────
              ResultClassificationSelector(
                selected: _selectedClassification,
                onSelected: (val) =>
                    setState(() => _selectedClassification = val),
              ),
              const SizedBox(height: 20),

              // ── Doctor Notes ───────────────────────────────────────────────
              DoctorReviewNotesField(controller: _notesController),
              const SizedBox(height: 28),

              // ── Submit ─────────────────────────────────────────────────────
              BlocBuilder<ResultsCubit, ResultsState>(
                builder: (context, state) {
                  return ReviewActionButton(
                    isLoading: state is ResultsLoading,
                    onPressed: _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
