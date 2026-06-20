import 'package:flutter/cupertino.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

class TextForms extends StatelessWidget {
  String title;
  String subtitle;

  TextForms({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyleBlack.display32),
          Text(subtitle, style: textStyleGrey.caption12),
        ],
      ),
    );
  }
}
