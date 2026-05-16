import 'package:flutter/material.dart';

/// Chip-based selector for Normal / Abnormal / Critical
class ResultClassificationSelector extends StatelessWidget {
  final String? selected;
  final void Function(String value) onSelected;

  const ResultClassificationSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _options = ['Normal', 'Abnormal', 'Critical'];

  Color _colorFor(String option) {
    switch (option) {
      case 'Normal':
        return const Color(0xFF0D9488); // teal
      case 'Abnormal':
        return const Color(0xFFF59E0B); // amber
      case 'Critical':
        return const Color(0xFFEF4444); // red
      default:
        return Colors.grey;
    }
  }

  IconData _iconFor(String option) {
    switch (option) {
      case 'Normal':
        return Icons.check_circle_outline;
      case 'Abnormal':
        return Icons.warning_amber_outlined;
      case 'Critical':
        return Icons.error_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Classification',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _options.map((option) {
            final isSelected = selected == option;
            final color = _colorFor(option);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onSelected(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.12) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _iconFor(option),
                          color: isSelected ? color : Colors.grey.shade400,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? color : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
