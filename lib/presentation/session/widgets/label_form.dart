import 'package:flutter/cupertino.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

class LabelForm extends StatelessWidget {
  String label;
  LabelForm({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: textStyleGrey.h124);
  }
}
