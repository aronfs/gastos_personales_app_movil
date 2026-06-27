import 'package:flutter/material.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
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
    if (_currentCtrl.text.isEmpty) {
      _showError('Ingresa tu contraseña actual');
      return;
    }
    if (_newCtrl.text.isEmpty) {
      _showError('Ingresa una nueva contraseña');
      return;
    }
    if (_newCtrl.text.length < 6) {
      _showError('La nueva contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      _showError('Las contraseñas no coinciden');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contraseña actualizada correctamente')),
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SettingsAppBar(title: 'Cambiar contraseña'),
            const SizedBox(height: 24),
            _buildField('Contraseña actual', _currentCtrl, _obscureCurrent, (v) => setState(() => _obscureCurrent = v)),
            const SizedBox(height: 16),
            _buildField('Nueva contraseña', _newCtrl, _obscureNew, (v) => setState(() => _obscureNew = v)),
            const SizedBox(height: 16),
            _buildField('Confirmar contraseña', _confirmCtrl, _obscureConfirm, (v) => setState(() => _obscureConfirm = v)),
            const SizedBox(height: 32),
            PrimaryActionButton(label: 'Guardar contraseña', onPressed: _handleSave),
            const SizedBox(height: 12),
            SecondaryActionButton(label: 'Cancelar', onPressed: () => Navigator.pop(context)),
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
