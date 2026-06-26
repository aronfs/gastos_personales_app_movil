import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/session/widgets/label_form.dart';
import 'package:gastos_personales/ui.theme/size_app.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_nameCtrl.text.trim().isEmpty) {
      _showError('Ingresa tu nombre');
      return;
    }
    if (_emailCtrl.text.trim().isEmpty || !_emailCtrl.text.contains('@')) {
      _showError('Ingresa un email válido');
      return;
    }
    if (_passwordCtrl.text.isEmpty) {
      _showError('Ingresa una contraseña');
      return;
    }
    if (_passwordCtrl.text.length < 6) {
      _showError('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      _showError('Las contraseñas no coinciden');
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamedAndRemoveUntil(context, home, (_) => false);
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.titleSignUp)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: LabelForm(label: appLocalizations.labelName),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(20),
                        child: FaIcon(FontAwesomeIcons.user),
                      ),
                      hintText: appLocalizations.hintName,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: LabelForm(label: appLocalizations.labelemail),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const FaIcon(FontAwesomeIcons.envelope),
                      ),
                      hintText: appLocalizations.hintEmail,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: LabelForm(label: appLocalizations.labelpassword),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: _passwordCtrl,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const FaIcon(FontAwesomeIcons.lock),
                      ),
                      hintText: appLocalizations.hintPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: LabelForm(label: appLocalizations.labelConfirmPassword),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: TextField(
                    controller: _confirmCtrl,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignup(),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const FaIcon(FontAwesomeIcons.lock),
                      ),
                      hintText: appLocalizations.labelConfirmPassword,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: SizedBox(
                    width: double.infinity,
                    height: sizeButton.height,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignup,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(appLocalizations.btnsignup),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
