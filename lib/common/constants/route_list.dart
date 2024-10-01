import 'package:sps/common/model/counseling_route_extra_data.dart';
import 'package:sps/common/model/phase_data.dart';
import 'package:sps/features/auth/ui/screen/login_screen.dart';
import 'package:sps/features/counseling_create/ui/screen/new_counseling_screen.dart';
import 'package:sps/features/counseling_list/ui/screen/counseling_list_screen.dart';
import 'package:sps/features/counseling_update/ui/screen/update_counseling_screen.dart';
import 'package:sps/features/notes/ui/screen/note_screen.dart';
import 'package:sps/features/patient_list/ui/screen/patient_list_screen.dart';
import 'package:sps/features/patient_details/ui/screen/patient_details_screen.dart';
import 'package:sps/features/report/ui/screen/report_screen.dart';
import 'package:sps/features/settings/ui/screen/font_change_screen.dart';
import 'package:sps/features/settings/ui/screen/setting_screen.dart';
import 'package:sps/home.dart';
import 'package:sps/splash_screen.dart';
import 'package:go_router/go_router.dart';

class RouteList {
  static final routeList = [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteName.setting,
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: RouteName.fontChange,
      builder: (context, state) => const FontChangeScreen(),
    ),
    GoRoute(
      path: RouteName.report,
      builder: (context, state) => const ReportScreen(),
    ),
    GoRoute(
      path: RouteName.note,
      builder: (context, state) => const NoteScreen(),
    ),
    GoRoute(
      path: RouteName.patient,
      builder: (context, state) => const PatientScreen(),
    ),
    GoRoute(
      path: '${RouteName.patientDetail}/:id',
      builder: (context, state) {
        final patientId = state.pathParameters['id']!;
        return PatientDetailsScreen(patientId: int.parse(patientId));
      },
    ),
    GoRoute(
      path: '${RouteName.patientCounselings}/:patientId',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        final PhaseData? phaseData = state.extra as PhaseData?;
        return CounselingScreen(
            patientId: int.parse(patientId), phase: phaseData!.phase);
      },
    ),
    GoRoute(
      path: '${RouteName.newCounseling}/:patientId', //RouteName.newCounseling,
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        final CounselingRouteExtraData? phaseData =
            state.extra as CounselingRouteExtraData?;

        return NewCounselingScreen(
            patientId: int.parse(patientId),
            phase: phaseData!.phase,
            dotsStartDate: phaseData.dotsStartDate);
      },
    ),
    GoRoute(
      path:
          '${RouteName.updateCounseling}/:patientId/:id', //RouteName.newCounseling,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final patientId = state.pathParameters['patientId']!;
        return UpdateCounselingScreen(
          id: int.parse(id),
          patientId: int.parse(patientId),
        );
      },
    ),
  ];
}

class RouteName {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String fontChange = '/fontChange';
  static const String report = '/report';
  static const String note = '/note';
  static const String patient = '/patient';
  static const String patientDetail = '/patient';
  static const String patientCounselings = '/patient-counselings';
  static const String newCounseling = '/new-counseling';
  static const String updateCounseling = '/update-counseling';
}
