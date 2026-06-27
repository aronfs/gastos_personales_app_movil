import 'package:flutter/material.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/screens/widgets/secondary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    final loc = AppLocalizations.of(context)!;
    if (_currentCtrl.text.isEmpty) {
      _showError(loc.enterCurrentPassword);
      return;
    }
    if (_newCtrl.text.isEmpty) {
      _showError(loc.enterNewPassword);
      return;
    }
    if (_newCtrl.text.length < 6) {
      _showError(loc.newPasswordMinLength);
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      _showError(loc.passwordsDoNotMatch);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.passwordUpdated)),
    );
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: Theme.of(context).colorScheme.error));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SettingsAppBar(title: loc.changePasswordTitle),
            const SizedBox(height: 24),
            _buildField(loc.currentPassword, _currentCtrl, _obscureCurrent, (v) => setState(() => _obscureCurrent = v)),
            const SizedBox(height: 16),
            _buildField(loc.newPassword, _newCtrl, _obscureNew, (v) => setState(() => _obscureNew = v)),
            const SizedBox(height: 16),
            _buildField(loc.confirmPassword, _confirmCtrl, _obscureConfirm, (v) => setState(() => _obscureConfirm = v)),
            const SizedBox(height: 32),
            PrimaryActionButton(label: loc.savePassword, onPressed: _handleSave),
            const SizedBox(height: 12),
            SecondaryActionButton(label: loc.cancel, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, bool obscure, ValueChanged<bool> onToggle) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
              onPressed: () => onToggle(!obscure),
            ),
          ),
        ),
      ),
    );
  }
}
