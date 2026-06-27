import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

class TextForms extends StatelessWidget {
  String title;
  String subtitle;

  TextForms({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyleBlack(cs).display32),
          Text(subtitle, style: textStyleGrey(cs).caption12),
        ],
      ),
    );
  }
}
