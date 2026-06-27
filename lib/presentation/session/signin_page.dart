import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/data/repositories/auth_repository.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/check_initial_setup_required.dart';
import 'package:gastos_personales/layers/dashboard/data/dashboard_repository_impl.dart';
import 'package:gastos_personales/layers/dashboard/data/source/network/dashboard_api.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/layers/login/data/login_repository_impl.dart';
import 'package:gastos_personales/layers/login/data/source/network/api.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/session/bloc/sign_in/sign_in_bloc.dart';
import 'package:gastos_personales/presentation/session/widgets/hint_label.dart';
import 'package:gastos_personales/presentation/session/widgets/label_form.dart';
import 'package:gastos_personales/presentation/session/widgets/text_forms.dart';
import 'package:gastos_personales/util/biometric_service.dart';
import 'package:gastos_personales/util/token_storage.dart';

/// Provee el [SignInBloc] y monta la pantalla.
class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignInBloc(loginRepository: LoginRepositoryImpl(api: ApiImpl())),
      child: const _SigninView(),
    );
  }
}

class _SigninView extends StatefulWidget {
  const _SigninView();

  @override
  State<_SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<_SigninView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _biometricEnabled = false;
  bool _biometricChecking = true;
  bool _biometricAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final enabled = await TokenStorage.isBiometricEnabled();
    final hasRefreshToken = await TokenStorage.hasRefreshToken();
    if (enabled && !hasRefreshToken) {
      await TokenStorage.setBiometricEnabled(false);
    }
    if (mounted) {
      setState(() {
        _biometricEnabled = enabled && hasRefreshToken;
        _biometricChecking = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() => setState(() => _isObscure = !_isObscure);

  void _submit(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    context.read<SignInBloc>().add(
      SignInRequested(email: email, password: password),
    );
  }

  Future<void> _signInWithBiometric(BuildContext context) async {
    if (_biometricAuthenticating) return;
    setState(() => _biometricAuthenticating = true);
    try {
      final authRepo = AuthRepository();
      await authRepo.loginWithBiometric();
      if (!mounted) return;
      if (context.mounted) {
        await _checkAndNavigateInitialSetup(context);
      }
    } catch (e) {
      if (!mounted) return;
      if (e is BiometricException &&
          (e.code == 'NotAvailable' || e.code == 'NotEnrolled')) {
        await _showEnrollBiometricDialog(context);
        return;
      }
      await _checkBiometric();
      final msg = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() => _biometricAuthenticating = false);
      }
    }
  }

  Future<void> _showEnrollBiometricDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.fingerprintNotRegisteredTitle),
        content: Text(loc.fingerprintNotRegisteredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.goToSettings),
          ),
        ],
      ),
    );
    if (goToSettings == true && mounted) {
      await BiometricService.openBiometricSettings();
    }
  }

  Future<void> _onLoginSuccess(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    if (!_biometricEnabled && mounted) {
      final accept = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(loc.enableFingerprintTitle),
          content: Text(loc.enableFingerprintMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(loc.notNow),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(loc.enable),
            ),
          ],
        ),
      );
      if (accept == true && mounted) {
        try {
          final authRepo = AuthRepository();
          await authRepo.enableBiometric();
          if (mounted) {
            setState(() => _biometricEnabled = true);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(loc.fingerprintActivated),
                ),
              );
          }
        } catch (e) {
          if (!mounted) return;
          if (e is BiometricException &&
              (e.code == 'NotAvailable' || e.code == 'NotEnrolled')) {
            await _showEnrollBiometricDialog(context);
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceAll('Exception: ', '')),
                ),
              );
          }
        }
      }
    }
    if (mounted) {
      _checkAndNavigateInitialSetup(context);
    }
  }

  Future<void> _checkAndNavigateInitialSetup(BuildContext context) async {
    final categoriesRepo = CategoriesRepositoryImpl(CategoriesApiImpl());
    final dashboardRepo = DashboardRepositoryImpl(DashboardApiImpl());
    final checkUseCase = CheckInitialSetupRequired(
      categoriesRepo,
      GetDashboard(dashboardRepo),
    );

    final needsSetup = await checkUseCase();

    if (!context.mounted) return;

    if (needsSetup) {
      Navigator.pushNamedAndRemoveUntil(context, initialSetup, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          _onLoginSuccess(context);
        } else if (state is SignInFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: cs.error),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  // ── Icon ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.wallet,
                      size: 30,
                      color: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Title & subtitle ────────────────────────────
                  TextForms(
                    title: loc.titleSignIn,
                    subtitle: loc.descriptionSignIn,
                  ),
                  const SizedBox(height: 20),

                  // ── Email ─────────────────────────────────────────
                  LabelForm(label: loc.labelemail),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.envelope),
                      ),
                      hintText: loc.hintEmail,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Password ──────────────────────────────────────
                  LabelForm(label: loc.labelpassword),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(context),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.lock),
                      ),
                      hintText: loc.hintPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: _togglePassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Forgot password ─────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(loc.labelforgotpassword),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Button / loading ───────────────────────────────
                  BlocBuilder<SignInBloc, SignInState>(
                    buildWhen: (_, curr) =>
                        curr is SignInLoading ||
                        curr is SignInInitial ||
                        curr is SignInFailure,
                    builder: (context, state) {
                      final isLoading = state is SignInLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _submit(context),
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: cs.onPrimary,
                                  ),
                                )
                              : Text(loc.btnsignin),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Biometric button ────────────────────────────
                  if (!_biometricChecking && _biometricEnabled) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _biometricAuthenticating
                            ? null
                            : () => _signInWithBiometric(context),
                        icon: _biometricAuthenticating
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cs.onPrimary,
                                ),
                              )
                            : const Icon(Icons.fingerprint),
                        label: Text(loc.signInWithBiometric),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Hint: No account? ──────────────────────
                  HintLabel(
                    label1: loc.labeldontaccount,
                    label2: loc.btnsignup,
                    toPage: signup,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
