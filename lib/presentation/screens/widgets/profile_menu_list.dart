import 'package:flutter/material.dart';
import 'profile_menu_item.dart';
import 'profile_menu_option.dart';

/// Lista vertical de opciones de menú del perfil, cada una en su propia
/// card separada por espacio (tal como en el diseño).
class ProfileMenuList extends StatelessWidget {
  final List<ProfileMenuOption> options;
  final double spacing;

  const ProfileMenuList({
    super.key,
    required this.options,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          ProfileMenuItem(
            icon: options[i].icon,
            title: options[i].title,
            onTap: options[i].onTap,
          ),
          if (i != options.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}
