import 'package:flutter/material.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/widgets/profile_header_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/profile_menu_list.dart';
import 'package:gastos_personales/presentation/screens/widgets/profile_menu_option.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = <ProfileMenuOption>[
      ProfileMenuOption(
        icon: Icons.person_outline,
        title: 'Información personal',
        onTap: () {},
      ),
      ProfileMenuOption(
        icon: Icons.credit_card_outlined,
        title: 'Métodos de pago',
        onTap: () {},
      ),
      ProfileMenuOption(
        icon: Icons.notifications_none,
        title: 'Notificaciones',
        onTap: () {},
      ),
      ProfileMenuOption(
        icon: Icons.shield_outlined,
        title: 'Seguridad',
        onTap: () {},
      ),
       ProfileMenuOption(
        icon: Icons.category_outlined,
        title: 'Categorías',
        onTap: () => Navigator.pushNamed(context, categories),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const ProfileHeaderCard(
              name: 'María Alarcón',
              email: 'maria@finova.app',
              initials: 'MA',
            ),
            const SizedBox(height: 20),
            ProfileMenuList(options: options),
          ],
        ),
      ),
    );
  }
}
