import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/login/data/login_repository_impl.dart';
import 'package:gastos_personales/layers/login/data/source/network/api.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/session/bloc/sign_in/sign_in_bloc.dart';
import 'package:gastos_personales/presentation/session/widgets/hint_label.dart';
import 'package:gastos_personales/presentation/session/widgets/label_form.dart';
import 'package:gastos_personales/presentation/session/widgets/text_forms.dart';
import 'package:gastos_personales/ui.theme/size_app.dart';
import 'package:gastos_personales/ui.theme/theme_app.dart';

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Theme(
      data: AppThemeData.themeForms,
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, home, (_) => false);
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
      
                    // ── Ícono ──────────────────────────────────────────
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
      
                    // ── Título y subtítulo ────────────────────────────
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
                    const SizedBox(height: 10),
      
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
                    const SizedBox(height: 10),
      
                    // ── Olvidé contraseña ─────────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        loc.labelforgotpassword,
                        style: TextStyle(color: cs.primary),
                      ),
                    ),
                    const SizedBox(height: 20),
      
                    // ── Botón / loading ───────────────────────────────
                    BlocBuilder<SignInBloc, SignInState>(
                      buildWhen: (_, curr) =>
                          curr is SignInLoading ||
                          curr is SignInInitial ||
                          curr is SignInFailure,
                      builder: (context, state) {
                        final isLoading = state is SignInLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: sizeButton.height,
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
      
                    // ── Hint: ¿No tienes cuenta? ──────────────────────
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
      ),
    );
  }
}
