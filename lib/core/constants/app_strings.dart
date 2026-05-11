/// Static string constants used across the Home feature.
abstract final class AppStrings {
  // ── Header ────────────────────────────────────────────────────────────────
  static const String homeGreeting = 'Good Morning,';
  static const String patientName = 'Ahmed Hassan';
  static const String avatarInitials = 'AH';

  // ── Upcoming Appointment ──────────────────────────────────────────────────
  static const String upcomingAppointment = 'Upcoming Appointment';
  static const String apptDate = 'OCT 12';
  static const String apptTime = '10:00';
  static const String apptAmPm = 'AM';
  static const String apptTitle = 'MRI Scan';
  static const String apptDoctor = 'Dr. Sarah M.';
  static const String apptConfirmed = 'Confirmed';

  // ── Live Queue ────────────────────────────────────────────────────────────
  static const String liveQueue = 'LIVE QUEUE';
  static const String queuePosition = 'You are #';
  static const String queueInQueue = ' in queue';

  // ── Quick Actions ─────────────────────────────────────────────────────────
  static const String quickActions = 'Quick Actions';
  static const String qaBookAppt = 'Book Appt';
  static const String qaResults = 'Results';
  static const String qaAlerts = 'Alerts';
  static const String qaMyAppts = 'My Appts';

  // ── Recent Activity ───────────────────────────────────────────────────────
  static const String recentActivity = 'Recent Activity';
  static const String seeAll = 'See All';
  static const String actCbcTitle = 'CBC Result Ready';
  static const String actCbcSubtitle =
      'Your laboratory results are now available for download.';
  static const String actCbcTime = '2h ago';
  static const String actApptTitle = 'Appt Confirmed';
  static const String actApptSubtitle =
      'MRI Scan with Dr. Sarah Mohammed is confirmed.';
  static const String actApptTime = '1d ago';

  // ── Bottom nav ────────────────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navAppts = 'Appts';
  static const String navAlerts = 'Alerts';
  static const String navProfile = 'Profile';

  // ── App routes ────────────────────────────────────────────────────────────
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String layoutRoute = '/layout';
  static const String homeRoute = '/home';
}
