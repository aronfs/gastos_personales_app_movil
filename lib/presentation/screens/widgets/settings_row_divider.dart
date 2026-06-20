import 'package:flutter/material.dart';

/// Línea divisora delgada usada entre filas dentro de una misma card
/// de configuración, respetando el margen del icono.
class SettingsRowDivider extends StatelessWidget {
  const SettingsRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFEFF0F4),
      ),
    );
  }
}
