import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';

class DepartmentSelector extends StatelessWidget {
  final String selectedDepartment;
  final ValueChanged<String> onDepartmentSelected;

  const DepartmentSelector({
    super.key,
    required this.selectedDepartment,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DepartmentCard(
            title: 'Radiology',
            subtitle: 'Imaging & Scans',
            icon: Icons.monitor_heart_outlined,
            isSelected: selectedDepartment == 'Radiology',
            onTap: () => onDepartmentSelected('Radiology'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _DepartmentCard(
            title: 'Laboratory',
            subtitle: 'Blood & Pathology\nTests',
            icon: Icons.science_outlined,
            isSelected: selectedDepartment == 'Laboratory',
            onTap: () => onDepartmentSelected('Laboratory'),
          ),
        ),
      ],
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DepartmentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0D9488).withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF0D9488) : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? const Color(0xFF0D9488) : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
