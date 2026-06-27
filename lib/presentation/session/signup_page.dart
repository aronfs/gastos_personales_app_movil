import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/check_initial_setup_required.dart';
import 'package:gastos_personales/layers/dashboard/data/dashboard_repository_impl.dart';
import 'package:gastos_personales/layers/dashboard/data/source/network/dashboard_api.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/layers/register/data/register_repository_impl.dart';
import 'package:gastos_personales/layers/register/data/source/network/api.dart';
import 'package:gastos_personales/layers/register/domain/usecase/sign_up.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/session/bloc/sign_up/sign_up_bloc.dart';
import 'package:gastos_personales/presentation/session/widgets/hint_label.dart';
import 'package:gastos_personales/presentation/session/widgets/label_form.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(
        signUp: SignUp(
          repository: RegisterRepositoryImpl(api: RegisterApiImpl()),
        ),
      ),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _togglePassword() => setState(() => _isObscure = !_isObscure);

  bool _validate() {
    final loc = AppLocalizations.of(context)!;
    if (_firstNameCtrl.text.trim().isEmpty) {
      _showError(loc.labelName.isNotEmpty ? 'Ingresa tu nombre' : loc.labelName);
      return false;
    }
    if (_lastNameCtrl.text.trim().isEmpty) {
      _showError('Ingresa tu apellido');
      return false;
    }
    if (_emailCtrl.text.trim().isEmpty || !_emailCtrl.text.contains('@')) {
      _showError('Ingresa un email válido');
      return false;
    }
    if (_passwordCtrl.text.isEmpty) {
      _showError('Ingresa una contraseña');
      return false;
    }
    if (_passwordCtrl.text.length < 6) {
      _showError('La contraseña debe tener al menos 6 caracteres');
      return false;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      _showError('Las contraseñas no coinciden');
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Theme.of(context).colorScheme.error),
      );
  }

  void _submit() {
    if (!_validate()) return;
    context.read<SignUpBloc>().add(
      SignUpRequested(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
      ),
    );
  }

  Future<void> _checkAndNavigate(BuildContext context) async {
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

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          _checkAndNavigate(context);
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: cs.error,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(loc.titleSignUp)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // ── First Name ─────────────────────────
                  LabelForm(label: 'Nombre'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _firstNameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.user),
                      ),
                      hintText: 'Tu nombre',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Last Name ──────────────────────────
                  LabelForm(label: 'Apellido'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _lastNameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.user),
                      ),
                      hintText: 'Tu apellido',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Email ────────────────────────────────
                  LabelForm(label: loc.labelemail),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
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

                  // ── Password ─────────────────────────────
                  LabelForm(label: loc.labelpassword),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.next,
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

                  // ── Confirm Password ─────────────────────
                  LabelForm(label: loc.labelConfirmPassword),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmCtrl,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.lock),
                      ),
                      hintText: loc.labelConfirmPassword,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility_off_outlined),
                        onPressed: _togglePassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Register button ──────────────────────
                  BlocBuilder<SignUpBloc, SignUpState>(
                    buildWhen: (_, curr) =>
                        curr is SignUpLoading ||
                        curr is SignUpInitial ||
                        curr is SignUpFailure,
                    builder: (context, state) {
                      final isLoading = state is SignUpLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(loc.btnsignup),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Hint: Already have account? ──────────
                  HintLabel(
                    label1: '¿Ya tienes cuenta? ',
                    label2: 'Inicia sesión',
                    toPage: signin,
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
