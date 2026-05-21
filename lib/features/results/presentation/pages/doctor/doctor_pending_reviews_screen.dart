import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/services/user_session_service.dart';
import '../../../../../shared/widgets/app_snackbar.dart';
import '../../cubit/results_cubit.dart';
import '../../cubit/results_state.dart';
import '../../widgets/doctor/pending_review_card.dart';

class DoctorPendingReviewsScreen extends StatefulWidget {
  final bool showBackButton;
  const DoctorPendingReviewsScreen({super.key, this.showBackButton = false});

  @override
  State<DoctorPendingReviewsScreen> createState() =>
      _DoctorPendingReviewsScreenState();
}

class _DoctorPendingReviewsScreenState
    extends State<DoctorPendingReviewsScreen> {
  @override
  void initState() {
    super.initState();

    _fetchPendingReviews();
  }

  void _fetchPendingReviews() {
    final doctorId = UserSessionService.currentUser?.id;
    if (doctorId != null) {
      context.read<ResultsCubit>().getDoctorPendingReviews(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: (widget.showBackButton || context.canPop())
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
          'Pending Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchPendingReviews,
          ),
        ],
      ),
      body: BlocConsumer<ResultsCubit, ResultsState>(
        listener: (context, state) {
          if (state is ResultsError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ResultsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D9488)),
            );
          } else if (state is ResultsLoaded) {
            final results = state.results;
            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No pending reviews found.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _fetchPendingReviews(),
              color: const Color(0xFF0D9488),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return PendingReviewCard(
                    result: result,
                    onReviewPressed: () async {
                      // Navigate to ReviewResultScreen
                      await context.push(
                        AppStrings.reviewResultRoute,
                        extra: result,
                      );
                      // Re-fetch after coming back
                      _fetchPendingReviews();
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
