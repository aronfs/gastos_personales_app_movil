import 'package:flutter/material.dart';
import 'glass_pill_button.dart';
import 'initials_avatar.dart';

/// Card de cabecera del perfil: fondo con degradado azul, avatar con
/// iniciales, nombre, correo y botón de "Editar perfil".
class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String initials;
  final VoidCallback? onEditProfile;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.initials,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2962FF),
            Color(0xFF1E88E5),
            Color(0xFF29B6F6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2962FF).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InitialsAvatar(initials: initials),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          GlassPillButton(
            label: 'Editar perfil',
            onPressed: onEditProfile,
          ),
        ],
      ),
    );
  }
}
