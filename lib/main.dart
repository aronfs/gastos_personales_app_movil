import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/navigation/navigation_app.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

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
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: splash,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateRoute: RouteGenerator.generateRoute,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: MaterialTheme.lightScheme(),
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: MaterialTheme.darkScheme(),
                brightness: Brightness.dark,
              ),
              themeMode: currentMode,
            );
          },
        );
      },
    );
  }
}
