import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/home/models/nav_item_model.dart';
import 'package:radiology_and_lab_app/features/home/view/home_view.dart';
import 'package:radiology_and_lab_app/features/home/view/widgets/home_bottom_nav_bar.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: _buildPage(),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        items: const [
          NavItemModel(iconData: Icons.home_rounded, label: 'Home'),
          NavItemModel(iconData: Icons.calendar_month_rounded, label: 'Appts'),
          NavItemModel(iconData: Icons.notifications_outlined, label: 'Alerts'),

          NavItemModel(iconData: Icons.person_outline, label: 'Profile'),
        ],
        selectedIndex: _selectedIndex,
        onItemTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
        onFabTap: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(title: Text('Fab')),
          );
        },
      ),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const SizedBox();
      case 2:
        return const SizedBox();
      case 3:
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }
}
