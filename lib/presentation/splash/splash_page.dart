import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';
import 'package:gastos_personales/ui.theme/theme_app.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/session_manager.dart';
import 'package:gastos_personales/util/token_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final cs = AppTheme.light.colorScheme;

    return Theme(
      data: AppTheme.light.copyWith(
        scaffoldBackgroundColor: cs.primary,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2563EB)),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: FaIcon(
                  FontAwesomeIcons.wallet,
                  size: 64,
                  color: cs.surface,
                ),
              ),
              Text(
                appLocalizations.titleSplash,
                style: textStyleWhite(cs).display32,
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.descriptionSplash,
                style: textStyleWhite(cs).body14,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _validateSession();
  }

  Future<void> _validateSession() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final hasBiometric = await TokenStorage.isBiometricEnabled();
    final hasToken = await TokenStorage.hasToken();
    final hasRefreshToken = await TokenStorage.hasRefreshToken();

    if (!mounted) return;

    if (hasBiometric) {
      Navigator.pushReplacementNamed(context, signin);
      return;
    }

    if (hasToken && hasRefreshToken) {
      try {
        final dio = DioClient().dio;
        await dio.post(ApiEndpoints.authRefresh, data: {
          'refreshToken': await TokenStorage.getRefreshToken(),
        });
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, home);
        return;
      } catch (_) {
        await SessionManager().forceLogout();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, signin);
        return;
      }
    }

    if (hasToken) {
      await TokenStorage.clearSession();
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, signin);
  }
}
