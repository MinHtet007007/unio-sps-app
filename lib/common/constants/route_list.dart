import 'package:sps/screens/home/home_screen.dart';
import 'package:sps/screens/add_new_package/add_new_package_screen.dart';
import 'package:sps/screens/login/login_screen.dart';
import 'package:sps/screens/notes/note_screen.dart';
import 'package:sps/screens/patient_detail/patient_detail_screen.dart';
import 'package:sps/screens/patients_list/patient_list_screen.dart';
import 'package:sps/screens/report/report_screen.dart';
import 'package:sps/features/settings/ui/screen/font_change_screen.dart';
import 'package:sps/features/settings/ui/screen/setting_screen.dart';
import 'package:sps/screens/splash_screen.dart';
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
      builder: (context, state) => const PatientListScreen(),
    ),
    GoRoute(
      path: '${RouteName.patientDetail}/:id',
      builder: (context, state) {
        final patientId = state.pathParameters['id']!;
        return PatientDetailScreen(patientId: int.parse(patientId));
      },
    ),
    GoRoute(
      path: '${RouteName.packageCreate}/:patientId',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        return AddNewPackageScreen(patientId: int.parse(patientId));
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
  static const String packageCreate = '/package-create';
}
