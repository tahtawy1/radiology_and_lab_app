import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/di/injection_container.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/pages/patint/my_appointments_screen.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/pages/doctor/doctor_approval_screen.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_patient_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/pages/admin/queue_admin_screen.dart';
import 'package:radiology_and_lab_app/features/dashboard/presentation/pages/doctor/doctor_notifications_screen.dart';

import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

import 'patient/patient_dashboard_screen.dart';
import 'doctor/doctor_dashboard_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  final UserEntity user;

  const MainDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.role.toLowerCase();

    if (role == 'admin') return _AdminShell(user: user);
    if (role == 'doctor') return _DoctorShell(user: user);
    return _PatientShell(user: user);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PATIENT SHELL
// Spec: Home | Appointments | Results | Notifications | Profile (5 tabs)
// No FAB needed.
// ─────────────────────────────────────────────────────────────────────────────
class _PatientShell extends StatelessWidget {
  final UserEntity user;
  const _PatientShell({required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<AppointmentCubit>(
          create: (_) => getIt<AppointmentCubit>(),
        ),
        BlocProvider<QueuePatientCubit>(
          create: (_) => getIt<QueuePatientCubit>(),
        ),
      ],
      child: _PatientScaffold(user: user),
    );
  }
}

class _PatientScaffold extends StatelessWidget {
  final UserEntity user;
  const _PatientScaffold({required this.user});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _TabItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
      label: 'Appointments',
    ),
    _TabItem(
      icon: Icons.science_outlined,
      activeIcon: Icons.science,
      label: 'Results',
    ),
    _TabItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'Notifications',
    ),
    _TabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navState) {
        final currentIndex =
            navState is NavigationIndexChanged ? navState.index : 0;

        final screens = [
          PatientDashboardScreen(user: user),
          BlocProvider<AppointmentCubit>.value(
            value: context.read<AppointmentCubit>(),
            child: const MyAppointmentsScreen(),
          ),
          const _PlaceholderTab(
            label: 'Results\nComing Soon',
            icon: Icons.science_outlined,
          ),
          const DoctorNotificationsScreen(),
          _ProfileTab(user: user),
        ];

        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: _AppBottomNav(
            tabs: _tabs,
            currentIndex: currentIndex,
            onTap: (i) => context.read<NavigationCubit>().goToTab(i),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOCTOR SHELL
// Spec: Home | Reviews | Approvals | Notifications | Profile (5 tabs)
// No FAB needed.
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorShell extends StatelessWidget {
  final UserEntity user;
  const _DoctorShell({required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<AppointmentCubit>(
          create: (_) => getIt<AppointmentCubit>(),
        ),
      ],
      child: _DoctorScaffold(user: user),
    );
  }
}

class _DoctorScaffold extends StatelessWidget {
  final UserEntity user;
  const _DoctorScaffold({required this.user});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _TabItem(
      icon: Icons.rate_review_outlined,
      activeIcon: Icons.rate_review,
      label: 'Reviews',
    ),
    _TabItem(
      icon: Icons.approval_outlined,
      activeIcon: Icons.approval,
      label: 'Approvals',
    ),
    _TabItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'Notifications',
    ),
    _TabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navState) {
        final currentIndex =
            navState is NavigationIndexChanged ? navState.index : 0;

        final screens = [
          DoctorDashboardScreen(user: user),
          const _PlaceholderTab(
            label: 'Reviews\nComing Soon',
            icon: Icons.rate_review_outlined,
          ),
          BlocProvider<AppointmentCubit>.value(
            value: context.read<AppointmentCubit>(),
            child: const DoctorApprovalScreen(),
          ),
          const DoctorNotificationsScreen(),
          _ProfileTab(user: user),
        ];

        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: _AppBottomNav(
            tabs: _tabs,
            currentIndex: currentIndex,
            onTap: (i) => context.read<NavigationCubit>().goToTab(i),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN SHELL
// Spec: Home | Queue | Results | Reports | Profile (5 tabs)
// FAB: Center-docked "Upload Result" button.
// ─────────────────────────────────────────────────────────────────────────────
class _AdminShell extends StatelessWidget {
  final UserEntity user;
  const _AdminShell({required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<QueueAdminCubit>(create: (_) => getIt<QueueAdminCubit>()),
        BlocProvider<AppointmentCubit>(
          create: (_) => getIt<AppointmentCubit>(),
        ),
      ],
      child: _AdminScaffold(user: user),
    );
  }
}

class _AdminScaffold extends StatelessWidget {
  final UserEntity user;
  const _AdminScaffold({required this.user});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _TabItem(
      icon: Icons.queue_outlined,
      activeIcon: Icons.queue,
      label: 'Queue',
    ),
    _TabItem(
      icon: Icons.science_outlined,
      activeIcon: Icons.science,
      label: 'Results',
    ),
    _TabItem(
      icon: Icons.assessment_outlined,
      activeIcon: Icons.assessment,
      label: 'Reports',
    ),
    _TabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navState) {
        final currentIndex =
            navState is NavigationIndexChanged ? navState.index : 0;

        final screens = [
          AdminDashboardScreen(user: user),
          BlocProvider<QueueAdminCubit>.value(
            value: context.read<QueueAdminCubit>(),
            child: const QueueAdminView(),
          ),
          const _PlaceholderTab(
            label: 'Results\nComing Soon',
            icon: Icons.science_outlined,
          ),
          const _PlaceholderTab(
            label: 'Reports\nComing Soon',
            icon: Icons.assessment_outlined,
          ),
          _ProfileTab(user: user),
        ];

        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryDark,
            elevation: 6,
            shape: const CircleBorder(),
            onPressed: () {
              // MVP: Upload result action placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload Result — coming soon')),
              );
            },
            child: const Icon(Icons.upload_file, color: Colors.white, size: 26),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _AdminBottomNav(
            tabs: _tabs,
            currentIndex: currentIndex,
            onTap: (i) => context.read<NavigationCubit>().goToTab(i),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED: Standard Bottom Navigation Bar (Patient + Doctor)
// ─────────────────────────────────────────────────────────────────────────────
class _AppBottomNav extends StatelessWidget {
  final List<_TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final tab = tabs[i];
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? AppColors.primaryDark.withValues(alpha: 0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? tab.activeIcon : tab.icon,
                        color:
                            isActive
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w400,
                          color:
                              isActive
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED: Admin Bottom Navigation Bar (with FAB notch)
// ─────────────────────────────────────────────────────────────────────────────
class _AdminBottomNav extends StatelessWidget {
  final List<_TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // First two tabs
            _buildNavItem(0),
            _buildNavItem(1),
            // Gap for FAB
            const SizedBox(width: 48),
            // Last two tabs
            _buildNavItem(3),
            _buildNavItem(4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final tab = tabs[index];
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.primaryDark.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? tab.activeIcon : tab.icon,
              color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color:
                    isActive ? AppColors.primaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED: Profile Tab
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final UserEntity user;
  const _ProfileTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 32,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientTop, AppColors.gradientMid],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.glassWhite20,
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildInfoCard(user),
                const SizedBox(height: 16),
                _buildSignOutButton(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(UserEntity u) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.person_outline, 'Full Name', u.fullName),
          const Divider(height: 24),
          _infoRow(Icons.email_outlined, 'Email', u.email),
          const Divider(height: 24),
          _infoRow(Icons.phone_outlined, 'Phone', u.phone),
          const Divider(height: 24),
          _infoRow(Icons.badge_outlined, 'National ID', u.nationalId),
          const Divider(height: 24),
          _infoRow(Icons.work_outline, 'Role', u.role.toUpperCase()),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryDark),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<AuthCubit>().signOut();
          context.go(AppStrings.loginRoute);
        },
        icon: const Icon(Icons.logout, color: AppColors.errorRed),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.errorRed,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.errorRed.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaceholderTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
