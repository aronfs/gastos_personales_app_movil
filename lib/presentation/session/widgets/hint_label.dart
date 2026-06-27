import 'package:flutter/widgets.dart';
import 'package:gastos_personales/ui.theme/design_tokens.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

class HintLabel extends StatelessWidget {
  String label1;
  String label2;
  String toPage;
  HintLabel({
    super.key,
    required this.label1,
    required this.label2,
    required this.toPage,
  });

  void onTap(String toPage, BuildContext context) {
    Navigator.pushNamed(context, toPage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label1, style: textStyleGrey.body14),

          GestureDetector(
            onTap: () => onTap(toPage, context),
            child: Text(label2, style: textStyleBlack.body14),
          ),
        ],
      ),
    );
  }
}
