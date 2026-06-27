import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

class LabelForm extends StatelessWidget {
  String label;
  LabelForm({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(label, style: textStyleGrey(cs).h124);
  }
}
