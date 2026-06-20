import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/session/widgets/label_form.dart';
import 'package:gastos_personales/ui.theme/size_app.dart';
import 'package:gastos_personales/ui.theme/theme_app.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isObscure = true;

  void togglePassword() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Theme(
      data: AppThemeData.themeForms,
      child: Scaffold(
        appBar: AppBar(title: Text(appLocalizations.titleSignUp)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: LabelForm(label: appLocalizations.labelName),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(20),
                          child: FaIcon(FontAwesomeIcons.user),
                        ),
                        hintText: appLocalizations.hintName,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: LabelForm(label: appLocalizations.labelemail),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const FaIcon(FontAwesomeIcons.envelope),
                        ),
                        hintText: appLocalizations.hintEmail,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: LabelForm(label: appLocalizations.labelpassword),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: TextField(
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const FaIcon(FontAwesomeIcons.lock),
                        ),
                        hintText: appLocalizations.hintPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: togglePassword,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: LabelForm(
                      label: appLocalizations.labelConfirmPassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: TextField(
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const FaIcon(FontAwesomeIcons.lock),
                        ),
                        hintText: appLocalizations.hintPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: togglePassword,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: TextField(
                      readOnly: true,
                      maxLines: null,
                      minLines: 2,
                      decoration: InputDecoration(
                        hintText: appLocalizations.descriptionPolities,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: SizedBox(
                      width: sizeButton.width,
                      height: sizeButton.height,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(appLocalizations.btnsignup),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
