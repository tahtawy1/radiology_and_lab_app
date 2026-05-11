/// Represents the patient's upcoming appointment card.
class AppointmentModel {
  const AppointmentModel({
    required this.date,
    required this.time,
    required this.amPm,
    required this.title,
    required this.doctorName,
    this.isConfirmed = false,
  });

  final String date;      // e.g. "OCT 12"
  final String time;      // e.g. "10:00"
  final String amPm;      // e.g. "AM"
  final String title;     // e.g. "MRI Scan"
  final String doctorName;
  final bool isConfirmed;
}
