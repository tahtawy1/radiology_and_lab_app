import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const TimeSlotSelector({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final times = [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          final isSelected = time == selectedTime;

          return GestureDetector(
            onTap: () => onTimeSelected(time),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF111827) : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
