import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.currentFirstName);
    _lastNameCtrl = TextEditingController(text: widget.currentLastName);
  }

  @override
  void dispose() {
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          Navigator.pop(context, true);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: cs.error),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // ── App bar ──────────────────────────────────────────
              Row(
                children: [
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit profile',
                    style: tt.headlineMedium?.copyWith(color: cs.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Form ──────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      label: 'First name',
                      controller: _firstNameCtrl,
                      icon: Icons.person_outline,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'First name is required';
                        }
                        if (v.trim().length < 2) {
                          return 'Minimum 2 characters';
                        }
                        if (v.trim().length > 100) {
                          return 'Maximum 100 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Last name',
                      controller: _lastNameCtrl,
                      icon: Icons.person_outline,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        if (v.trim().length < 2) {
                          return 'Minimum 2 characters';
                        }
                        if (v.trim().length > 100) {
                          return 'Maximum 100 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Buttons ───────────────────────────────────────────
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (_, curr) =>
                    curr is ProfileOperationLoading || curr is ProfileLoaded,
                builder: (context, state) {
                  final isLoading = state is ProfileOperationLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSave,
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Save changes'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: cs.surface,
      ),
    );
  }
}
