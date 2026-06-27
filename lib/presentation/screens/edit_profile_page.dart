import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_bloc.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final String currentFirstName;
  final String currentLastName;

  const EditProfilePage({
    super.key,
    required this.currentFirstName,
    required this.currentLastName,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.currentFirstName);
    _lastNameCtrl = TextEditingController(text: widget.currentLastName);
    _firstNameCtrl.addListener(_onFieldChanged);
    _lastNameCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final changed = _firstNameCtrl.text != widget.currentFirstName ||
        _lastNameCtrl.text != widget.currentLastName;
    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.removeListener(_onFieldChanged);
    _lastNameCtrl.removeListener(_onFieldChanged);
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: cs.onPrimary, size: 20),
                    const SizedBox(width: 12),
                    Text(state.message),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: cs.primary,
              ),
            );
          Navigator.pop(context, true);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: ListView(
              controller: scrollController,
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        loc.editProfileTitle,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Material(
                      color: cs.surfaceContainerLow,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(Icons.close_rounded, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información personal',
                          style: tt.labelLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          label: loc.firstname,
                          controller: _firstNameCtrl,
                          icon: Icons.person_outline_rounded,
                          cs: cs,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return loc.firstnameRequired;
                            }
                            if (v.trim().length < 2) return loc.firstnameMin;
                            if (v.trim().length > 100) return loc.firstnameMax;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          label: loc.lastname,
                          controller: _lastNameCtrl,
                          icon: Icons.person_outline_rounded,
                          cs: cs,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return loc.lastnameRequired;
                            }
                            if (v.trim().length < 2) return loc.lastnameMin;
                            if (v.trim().length > 100) return loc.lastnameMax;
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildButtons(context, loc, cs),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context, AppLocalizations loc, ColorScheme cs) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, curr) =>
          curr is ProfileOperationLoading || curr is ProfileLoaded,
      builder: (context, state) {
        final isLoading = state is ProfileOperationLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: isLoading || !_hasChanges ? null : _handleSave,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          loc.saveChangesButton,
                          key: const ValueKey('save'),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(loc.cancel),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ColorScheme cs,
    required String? Function(String?)? validator,
  }) {
    return Focus(
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasFocus ? cs.primary : cs.outlineVariant,
              width: hasFocus ? 1.5 : 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, size: 20),
              filled: true,
              fillColor: cs.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        );
      }),
    );
  }
}
