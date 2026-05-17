import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/user_session_service.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationBell extends StatefulWidget {
  final Color? iconColor;
  const NotificationBell({super.key, this.iconColor});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeAnimationController;

  @override
  void initState() {
    super.initState();
    _badgeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize notification watch stream
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final role = UserSessionService.currentUser?.role ?? 'patient';
    if (userId.isNotEmpty) {
      context.read<NotificationsCubit>().listenToNotifications(userId, role);
    }
  }

  @override
  void dispose() {
    _badgeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsLoaded && state.unreadCount > 0) {
          _badgeAnimationController.forward();
        } else {
          _badgeAnimationController.reverse();
        }
      },
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationsLoaded) {
          unreadCount = state.unreadCount;
        }

        final displayCount = unreadCount > 99 ? '99+' : unreadCount.toString();

        return IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: widget.iconColor ?? const Color(0xFF0F766E),
                size: 26,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -4,
                  top: -2,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _badgeAnimationController,
                      curve: Curves.elasticOut,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent, // Elegant hospital alert red
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          displayCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            context.push(AppStrings.notificationsRoute);
          },
        );
      },
    );
  }
}
