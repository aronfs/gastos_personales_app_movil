import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/profile/data/profile_repository_impl.dart';
import 'package:gastos_personales/layers/profile/data/source/network/profile_api.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/delete_profile_image.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/get_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/update_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/upload_profile_image.dart';
import 'package:gastos_personales/main.dart' show themeNotifier;
import 'package:gastos_personales/presentation/providers/profile_provider.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_bloc.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_state.dart';
import 'package:gastos_personales/util/session_manager.dart';

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

class _ProfileViewState extends State<_ProfileView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final List<Animation<double>> _itemAnimations;
  final _scrollController = ScrollController();
  final _picker = ImagePicker();

  bool _isEditing = false;
  bool _showDeleteConfirm = false;
  bool _showLogoutConfirm = false;
  bool _showImageOptions = false;

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;
  File? _selectedFile;

  static const _itemCount = 6;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _itemAnimations = List.generate(_itemCount, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(i * 0.1, 0.5 + i * 0.08, curve: Curves.easeOutCubic),
        ),
      );
    });
    _staggerController.forward();

    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _scrollController.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  void _initFormControllers(Profile profile) {
    if (_firstNameCtrl.text.isEmpty && _lastNameCtrl.text.isEmpty) {
      _firstNameCtrl.text = profile.firstName;
      _lastNameCtrl.text = profile.lastName;
      _firstNameCtrl.addListener(_onFieldChanged);
      _lastNameCtrl.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    final firstName = _firstNameCtrl.text;
    final lastName = _lastNameCtrl.text;
    final profile = _currentProfile();
    final changed = profile != null &&
        (firstName != profile.firstName || lastName != profile.lastName);
    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  Profile? _currentProfile() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) return state.profile;
    if (state is ProfileOperationLoading) return state.profile;
    if (state is ProfileSuccess) return state.profile;
    if (state is ProfileError) return state.profile;
    return null;
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

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _hasChanges = false;
      final profile = _currentProfile();
      if (profile != null) {
        _firstNameCtrl.text = profile.firstName;
        _lastNameCtrl.text = profile.lastName;
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    setState(() {
      _selectedFile = File(picked.path);
      _showImageOptions = false;
    });
    context.read<ProfileBloc>().add(
      ProfileImageUploadRequested(filePath: picked.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isLight = cs.brightness == Brightness.light;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          if (_isEditing) {
            setState(() {
              _isEditing = false;
              _hasChanges = false;
            });
          }
          context.read<ProfileBloc>().add(const ProfileFetchRequested());
          context.read<ProfileImageProvider>().loadImage();
        } else if (state is ProfileError && state.profile == null) {
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
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return _buildSkeleton(cs);
        }

        if (state is ProfileError && state.profile == null) {
          return _buildErrorState(cs, tt, loc);
        }

        final profile = state is ProfileLoaded
            ? state.profile
            : (state is ProfileOperationLoading
                ? state.profile
                : (state is ProfileSuccess
                    ? state.profile
                    : (state is ProfileError ? state.profile : null)));

        if (profile == null) {
          return _buildSkeleton(cs);
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

        if (!_isEditing) {
          _initFormControllers(profile);
        }

        return Scaffold(
          body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ProfileBloc>()
                        .add(const ProfileFetchRequested());
                    await context.read<ProfileImageProvider>().loadImage();
                  },
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                    children: [
                      _buildAnimatedItem(
                        0,
                        _buildHeaderCard(
                          context,
                          profile,
                          initials,
                          isOperationLoading,
                          cs,
                          tt,
                          loc,
                          isLight,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedItem(
                        1,
                        _buildSectionHeader(context, loc.account, cs, tt),
                      ),
                      const SizedBox(height: 10),
                      _buildAnimatedItem(
                        2,
                        _GlassTile(
                          icon: Icons.edit_rounded,
                          label: loc.editProfile,
                          onTap: () => setState(() {
                            _isEditing = !_isEditing;
                            _showDeleteConfirm = false;
                            _showLogoutConfirm = false;
                          }),
                          isActive: _isEditing,
                          cs: cs,
                          isLight: isLight,
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _isEditing
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox(width: double.infinity),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _buildEditSection(cs, tt, loc, isLight),
                        ),
                        sizeCurve: Curves.easeOutCubic,
                      ),
                      const SizedBox(height: 16),
                      _buildAnimatedItem(
                        3,
                        _buildSectionHeader(
                            context, loc.preferences, cs, tt),
                      ),
                      const SizedBox(height: 10),
                      _buildAnimatedItem(
                        4,
                        _GlassTile(
                          icon: themeNotifier.value == ThemeMode.dark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          label: loc.darkMode,
                          trailing: _ThemeToggle(cs: cs),
                          onTap: () {
                            themeNotifier.value =
                                themeNotifier.value == ThemeMode.dark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                          },
                          cs: cs,
                          isLight: isLight,
                        ),
                      ),
                      if (profile.profileImage != null) ...[
                        const SizedBox(height: 16),
                        _buildAnimatedItem(
                          5,
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _showDeleteConfirm
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: _GlassTile(
                              icon: Icons.delete_rounded,
                              label: loc.deleteImage,
                              iconColor: cs.error,
                              textColor: cs.error,
                              onTap: isOperationLoading
                                  ? null
                                  : () => setState(() {
                                        _showDeleteConfirm = true;
                                        _showLogoutConfirm = false;
                                      }),
                              cs: cs,
                              isLight: isLight,
                            ),
                            secondChild: _buildInlineConfirm(
                              message: loc.confirmDeleteImage,
                              hint: loc.confirmDeleteImageHint,
                              confirmLabel: loc.confirm,
                              onConfirm: () {
                                context.read<ProfileBloc>().add(
                                  const ProfileImageDeleteRequested(
                                      confirmation: 'DELETE'),
                                );
                                setState(() => _showDeleteConfirm = false);
                              },
                              onCancel: () =>
                                  setState(() => _showDeleteConfirm = false),
                              cs: cs,
                              isLight: isLight,
                            ),
                            sizeCurve: Curves.easeOutCubic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _showLogoutConfirm
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: _GlassTile(
                          icon: Icons.logout_rounded,
                          label: loc.logout,
                          iconColor: cs.error,
                          textColor: cs.error,
                          onTap: () => setState(() {
                            _showLogoutConfirm = true;
                            _showDeleteConfirm = false;
                          }),
                          cs: cs,
                          isLight: isLight,
                        ),
                        secondChild: _buildInlineConfirm(
                          message: loc.confirmLogout,
                          hint: loc.confirmLogoutHint,
                          confirmLabel: loc.confirm,
                          onConfirm: () async {
                            await SessionManager()
                                .logout(preserveBiometric: true);
                          },
                          onCancel: () =>
                              setState(() => _showLogoutConfirm = false),
                          cs: cs,
                          isLight: isLight,
                          isDanger: true,
                        ),
                        sizeCurve: Curves.easeOutCubic,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (context, child) {
        return Opacity(
          opacity: _itemAnimations[index].value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - _itemAnimations[index].value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    Profile profile,
    String initials,
    bool isOperationLoading,
    ColorScheme cs,
    TextTheme tt,
    AppLocalizations loc,
    bool isLight,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: isLight
            ? Colors.white.withValues(alpha: 0.65)
            : Colors.white.withValues(alpha: 0.07),
        border: Border.all(
          color: isLight
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? Colors.black.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAvatar(context, initials, isOperationLoading, cs),
          const SizedBox(height: 20),
          Text(
            profile.fullName,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.email,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (profile.roles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.roles.map<Widget>((role) {
                  final label = role == role.toUpperCase()
                      ? role[0] + role.substring(1).toLowerCase()
                      : role;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isLight
                          ? cs.primaryContainer.withValues(alpha: 0.6)
                          : cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isLight
                            ? cs.primary.withValues(alpha: 0.3)
                            : cs.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      label,
                      style: tt.labelSmall?.copyWith(
                        color: isLight ? cs.primary : cs.primaryFixed,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          _StatusBadge(
            active: profile.active,
            cs: cs,
            tt: tt,
            loc: loc,
            isLight: isLight,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    String initials,
    bool isLoading,
    ColorScheme cs,
  ) {
    return Consumer<ProfileImageProvider>(
      builder: (context, provider, _) {
        final hasUploadedImage = provider.imageBytes != null;
        final hasSelectedFile = _selectedFile != null;
        final showImage = hasUploadedImage || hasSelectedFile;
        final providerLoading = provider.isLoading;
        final showLoading = isLoading || providerLoading;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'profile_photo',
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.10),
                      blurRadius: 48,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () =>
                        setState(() => _showImageOptions = !_showImageOptions),
                    splashColor: cs.primary.withValues(alpha: 0.15),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: cs.surface.withValues(alpha: 0.3),
                          backgroundImage: hasSelectedFile
                              ? FileImage(_selectedFile!)
                              : (hasUploadedImage
                                  ? MemoryImage(provider.imageBytes!)
                                  : null),
                          child: showImage
                              ? null
                              : Text(
                                  initials.isNotEmpty ? initials : '?',
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                        if (showLoading)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cs.surface,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.shadow.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 15,
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: _showImageOptions
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ImageOptionButton(
                            icon: Icons.camera_alt_rounded,
                            label: AppLocalizations.of(context)!.camera,
                            onTap: () => _pickImage(ImageSource.camera),
                            cs: cs,
                            isLight: _isLight(cs),
                          ),
                          const SizedBox(width: 12),
                          _ImageOptionButton(
                            icon: Icons.photo_library_rounded,
                            label: AppLocalizations.of(context)!.gallery,
                            onTap: () => _pickImage(ImageSource.gallery),
                            cs: cs,
                            isLight: _isLight(cs),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
            ),
          ],
        );
      },
    );
  }

  bool _isLight(ColorScheme cs) => cs.brightness == Brightness.light;

  Widget _buildEditSection(
    ColorScheme cs,
    TextTheme tt,
    AppLocalizations loc,
    bool isLight,
  ) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isLight
              ? Colors.white.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.06),
          border: Border.all(
            color: isLight
                ? cs.primary.withValues(alpha: 0.3)
                : cs.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_rounded,
                      size: 20, color: cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    loc.personalInfo,
                    style: tt.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildField(
                label: loc.firstName,
                controller: _firstNameCtrl,
                icon: Icons.person_outline_rounded,
                cs: cs,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return loc.firstnameRequired;
                  if (v.trim().length < 2) return loc.firstnameMin;
                  if (v.trim().length > 100) return loc.firstnameMax;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                label: loc.lastName,
                controller: _lastNameCtrl,
                icon: Icons.person_outline_rounded,
                cs: cs,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return loc.lastnameRequired;
                  if (v.trim().length < 2) return loc.lastnameMin;
                  if (v.trim().length > 100) return loc.lastnameMax;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _hasChanges ? _handleSave : null,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(loc.saveChangesButton),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _cancelEdit,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(loc.cancel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: tt.labelSmall?.copyWith(
          color: cs.onSurfaceVariant.withValues(alpha: 0.6),
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInlineConfirm({
    required String message,
    required String hint,
    required String confirmLabel,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required ColorScheme cs,
    required bool isLight,
    bool isDanger = false,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: (isDanger ? cs.error : cs.primary)
              .withValues(alpha: isLight ? 0.08 : 0.12),
          border: Border.all(
            color: (isDanger ? cs.error : cs.primary)
                .withValues(alpha: isLight ? 0.25 : 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isDanger ? Icons.warning_rounded : Icons.info_outline_rounded,
                  size: 20,
                  color: isDanger ? cs.error : cs.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            if (hint.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  hint,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDanger ? cs.error : cs.primary,
                    foregroundColor:
                        isDanger ? cs.onError : cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    minimumSize: Size.zero,
                  ),
                  child: Text(confirmLabel),
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildSkeleton(ColorScheme cs) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          children: [
            _ShimmerBox(
              height: 360,
              radius: 32,
              baseColor: cs.surfaceContainerHigh,
            ),
            const SizedBox(height: 24),
            _ShimmerBox(
              height: 16,
              radius: 8,
              baseColor: cs.surfaceContainerHigh,
            ),
            const SizedBox(height: 12),
            _ShimmerBox(
              height: 60,
              radius: 20,
              baseColor: cs.surfaceContainerHigh,
            ),
            const SizedBox(height: 20),
            _ShimmerBox(
              height: 16,
              radius: 8,
              baseColor: cs.surfaceContainerHigh,
            ),
            const SizedBox(height: 12),
            _ShimmerBox(
              height: 60,
              radius: 20,
              baseColor: cs.surfaceContainerHigh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ColorScheme cs, TextTheme tt, AppLocalizations loc) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.error_outline_rounded,
                      size: 40, color: cs.error),
                ),
                const SizedBox(height: 24),
                Text(
                  'Could not load profile',
                  textAlign: TextAlign.center,
                  style: tt.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context
                      .read<ProfileBloc>()
                      .add(const ProfileFetchRequested()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(loc.retryLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  final ColorScheme cs;
  final TextTheme tt;
  final AppLocalizations loc;
  final bool isLight;

  const _StatusBadge({
    required this.active,
    required this.cs,
    required this.tt,
    required this.loc,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? cs.tertiary.withValues(alpha: 0.12)
            : cs.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? cs.tertiary.withValues(alpha: 0.3)
              : cs.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? cs.tertiary : cs.error,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            active ? loc.active : loc.inactive,
            style: tt.labelSmall?.copyWith(
              color: active ? cs.tertiary : cs.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isActive;
  final ColorScheme cs;
  final bool isLight;

  const _GlassTile({
    required this.icon,
    required this.label,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.onTap,
    this.isActive = false,
    required this.cs,
    required this.isLight,
  });

  @override
  State<_GlassTile> createState() => _GlassTileState();
}

class _GlassTileState extends State<_GlassTile>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.iconColor ?? widget.cs.onSurface;
    final textColor = widget.textColor ?? widget.cs.onSurface;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _scale = 0.96) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _scale = 1.0) : null,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            splashColor: widget.cs.primary.withValues(alpha: 0.08),
            highlightColor: widget.cs.primary.withValues(alpha: 0.04),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: widget.isActive
                    ? widget.cs.primary.withValues(alpha: widget.isLight ? 0.10 : 0.15)
                    : widget.isLight
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.06),
                border: Border.all(
                  color: widget.isActive
                      ? widget.cs.primary.withValues(alpha: 0.3)
                      : widget.isLight
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: iconColor.withValues(alpha: 0.10),
                    ),
                    child: Icon(widget.icon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (widget.trailing != null)
                    widget.trailing!
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: widget.cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatefulWidget {
  final ColorScheme cs;

  const _ThemeToggle({required this.cs});

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void didUpdateWidget(covariant _ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cs.brightness != widget.cs.brightness) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.cs.brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, _) {
        return Transform.rotate(
          angle: _rotation.value * 3.14159,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
            ),
            child: Align(
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFF59E0B),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImageOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isLight;

  const _ImageOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cs,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isLight
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.10),
          border: Border.all(
            color: isLight
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: cs.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double height;
  final double radius;
  final Color baseColor;

  const _ShimmerBox({
    required this.height,
    required this.radius,
    required this.baseColor,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: widget.baseColor.withValues(alpha: _animation.value),
          ),
        );
      },
    );
  }
}
