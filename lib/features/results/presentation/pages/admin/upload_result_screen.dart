import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/services/user_session_service.dart';

import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_cubit.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_state.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

/// Used by Admin / Lab staff to upload a test result
/// for a confirmed appointment.
class UploadResultScreen extends StatefulWidget {
  final String appointmentId;
  final String patientName;
  final String testType;

  const UploadResultScreen({
    super.key,
    required this.appointmentId,
    required this.patientName,
    required this.testType,
  });

  @override
  State<UploadResultScreen> createState() => _UploadResultScreenState();
}

class _UploadResultScreenState extends State<UploadResultScreen> {
  final TextEditingController _notesController = TextEditingController();

  String? _fileName;
  String? _filePath;
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null) {
        final fileName = result.files.single.name;
        final lowerName = fileName.toLowerCase();
        
        if (!lowerName.endsWith('.pdf') && 
            !lowerName.endsWith('.jpg') && 
            !lowerName.endsWith('.jpeg') && 
            !lowerName.endsWith('.png')) {
          if (mounted) {
            AppSnackBar.showError(
              context, 
              'Unsupported file format. Please upload a PDF, JPG, or PNG file.',
            );
          }
          return;
        }

        setState(() {
          _fileName = fileName;
          _filePath = result.files.single.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Error picking file: $e');
    }
  }

  void _submit() {
    if (_filePath == null) {
      AppSnackBar.showError(context, 'Please upload a result file first.');
      return;
    }
    context.read<ResultsCubit>().uploadResult(
      appointmentId: widget.appointmentId,
      filePath: _filePath!,
      notes: _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppStrings.dashboardRoute, extra: UserSessionService.currentUser);
                  }
                },
              )
            : null,
        title: const Text(
          'Upload Test Result',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<ResultsCubit, ResultsState>(
        listener: (context, state) {
          if (state is ResultsActionSuccess) {
            AppSnackBar.showSuccess(context, state.message);
            context.pop();
          }

          if (state is ResultsError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: BlocBuilder<ResultsCubit, ResultsState>(
          builder: (context, state) {
            final bool isLoading = state is ResultsLoading;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ───────── Patient Info ─────────
                      _SectionCard(
                        label: 'Select Patient',
                        child: _InfoRow(
                          initials: _initials(widget.patientName),
                          title: widget.patientName,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ───────── Test Type ─────────
                      _SectionCard(
                        label: 'Test Type / Request',
                        child: Text(
                          widget.testType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ───────── Upload Document ─────────
                      const Text(
                        'Upload Document',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: _pickFile,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            color:
                                _filePath != null
                                    ? const Color(0xFF0D9488).withValues(alpha: 0.06)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  _filePath != null
                                      ? const Color(0xFF0D9488)
                                      : Colors.grey.shade300,
                              width: _filePath != null ? 2 : 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _filePath != null
                                    ? Icons.check_circle_outline
                                    : Icons.cloud_upload_outlined,
                                size: 40,
                                color:
                                    _filePath != null
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade400,
                              ),

                              const SizedBox(height: 10),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  _filePath != null
                                      ? 'File selected: $_fileName'
                                      : 'Tap to upload file',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _filePath != null
                                            ? const Color(0xFF0D9488)
                                            : Colors.grey.shade600,
                                  ),
                                ),
                              ),

                              if (_filePath == null) ...[
                                const SizedBox(height: 4),

                                Text(
                                  'Maximum file size: 25MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Wrap(
                                  spacing: 6,
                                  children:
                                      ['PDF', 'JPG', 'PNG', 'DICOM']
                                          .map(
                                            (ext) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                ext,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ───────── Notes ─────────
                      const Text(
                        'Lab / Admin Notes (optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _notesController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Any relevant notes for the doctor...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0D9488),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// ───────── Submit Button ─────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon:
                              isLoading
                                  ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.upload_file),
                          label: Text(
                            isLoading
                                ? 'Uploading...'
                                : 'Confirm & Submit Result',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// ───────── Loading Overlay ─────────
                if (isLoading)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// ─────────────────────────────────────────────────────────
/// Section Card
/// ─────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String label;
  final Widget child;

  const _SectionCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: child,
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// Info Row
/// ─────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String initials;
  final String title;

  const _InfoRow({required this.initials, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.15),
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF0D9488),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
              ),

            ],
          ),
        ),

        const Icon(Icons.check_circle, color: Color(0xFF0D9488), size: 20),
      ],
    );
  }
}
