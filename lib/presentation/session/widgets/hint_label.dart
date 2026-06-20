import 'package:flutter/widgets.dart';
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
    // Lógica para manejar el tap en label2
    Navigator.pushNamed(context, toPage);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.3,
        bottom: screenHeight * 0.02,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
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
