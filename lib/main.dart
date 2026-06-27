import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/navigation/navigation_app.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/ui.theme/theme_app.dart';
import 'package:gastos_personales/util/session_manager.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    SessionManager().onSessionExpired.listen((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        signin,
        (_) => false,
      );
    });
  }

  @override
  void dispose() {
    SessionManager().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              initialRoute: splash,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateRoute: RouteGenerator.generateRoute,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: currentMode,
            );
          },
        );
      },
    );
  }
}
