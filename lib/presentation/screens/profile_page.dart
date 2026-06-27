import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gastos_personales/layers/profile/data/profile_repository_impl.dart';
import 'package:gastos_personales/layers/profile/data/source/network/profile_api.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/deactivate_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/delete_profile_image.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/get_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/update_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/upload_profile_image.dart';
import 'package:gastos_personales/presentation/providers/profile_provider.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_bloc.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_state.dart';
import 'package:gastos_personales/presentation/screens/edit_profile_page.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/widgets/deactivate_account_dialog.dart';
import 'package:gastos_personales/presentation/screens/widgets/profile_avatar.dart';
import 'package:gastos_personales/util/token_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ProfileRepositoryImpl(ProfileApiImpl());
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(
            getProfile: GetProfile(repo),
            updateProfile: UpdateProfile(repo),
            deactivateProfile: DeactivateProfile(repo),
            uploadProfileImage: UploadProfileImage(repo),
            deleteProfileImage: DeleteProfileImage(repo),
          )..add(const ProfileFetchRequested()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileImageProvider()..loadImage(),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete profile image'),
        content: const Text(
          'Are you sure you want to delete your profile photo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(
                const ProfileImageDeleteRequested(confirmation: 'DELETE'),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          context.read<ProfileBloc>().add(const ProfileFetchRequested());
          context.read<ProfileImageProvider>().loadImage();
        } else if (state is ProfileError && state.profile == null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: cs.error),
            );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError && state.profile == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: cs.error),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.read<ProfileBloc>().add(
                        const ProfileFetchRequested(),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final profile = state is ProfileLoaded
            ? state.profile
            : (state is ProfileOperationLoading
                  ? state.profile
                  : (state is ProfileSuccess
                        ? state.profile
                        : (state is ProfileError ? state.profile : null)));

        if (profile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isOperationLoading = state is ProfileOperationLoading;
        final initials = profile.fullName.isNotEmpty
            ? profile.fullName
                  .split(' ')
                  .map((w) => w.isNotEmpty ? w[0] : '')
                  .take(2)
                  .join()
                  .toUpperCase()
            : '?';

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                // ── Profile header card ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(1.2, 1.0),
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1D4ED8),
                        Color(0xFF1E3A8A),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      ProfileAvatar(
                        initials: initials,
                        radius: 48,
                        showLoadingOverlay: isOperationLoading,
                        onImageSelected: (path) {
                          context.read<ProfileBloc>().add(
                            ProfileImageUploadRequested(filePath: path),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        profile.fullName,
                        style: tt.headlineLarge?.copyWith(color: cs.surface),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        profile.email,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.surface.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Roles
                      if (profile.roles.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: profile.roles.map((role) {
                            final label = role == role.toUpperCase()
                                ? role[0] + role.substring(1).toLowerCase()
                                : role;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: cs.surface.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: cs.surface.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                label,
                                style: tt.labelSmall?.copyWith(
                                  color: cs.surface,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 12),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: profile.active
                              ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                              : cs.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: profile.active
                                    ? const Color(0xFF22C55E)
                                    : cs.error,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              profile.active ? 'Active' : 'Inactive',
                              style: tt.labelSmall?.copyWith(
                                color: profile.active
                                    ? const Color(0xFF22C55E)
                                    : cs.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Action buttons ───────────────────────────────────
                _ActionButton(
                  icon: Icons.person_outline,
                  label: 'Edit profile',
                  onTap: () async {
                    final bloc = context.read<ProfileBloc>();
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: bloc,
                          child: EditProfilePage(
                            currentFirstName: profile.firstName,
                            currentLastName: profile.lastName,
                          ),
                        ),
                      ),
                    );
                    if (result == true && context.mounted) {
                      context.read<ProfileBloc>().add(
                        const ProfileFetchRequested(),
                      );
                    }
                  },
                ),
                if (profile.profileImage != null) ...[
                  const SizedBox(height: 10),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete image',
                    textColor: cs.error,
                    onTap: isOperationLoading
                        ? null
                        : () => _showDeleteConfirmation(context),
                  ),
                ],
                const SizedBox(height: 10),
                _ActionButton(
                  icon: Icons.block_outlined,
                  label: 'Deactivate account',
                  textColor: cs.error,
                  onTap: isOperationLoading
                      ? null
                      : () => showDialog(
                          context: context,
                          builder: (_) => DeactivateAccountDialog(
                            onConfirm: () {
                              context.read<ProfileBloc>().add(
                                const ProfileDeactivateRequested(
                                  confirmation: 'DEACTIVATE',
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  textColor: cs.error,
                  onTap: () async {
                    await TokenStorage.clearSession(
                      preserveBiometricLogin: true,
                    );
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        signin,
                        (_) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? textColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = textColor ?? cs.onSurface;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 22,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
