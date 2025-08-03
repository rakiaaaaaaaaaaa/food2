import 'package:flutter/material.dart';
import 'package:food2/common/extension.dart';
import 'package:food2/view/login/login_view.dart';
import 'package:food2/view/login/otp_view.dart';
import '../../common/globs.dart';
import '../../common/service_call.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  TextEditingController txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Dots icon
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),

            const SizedBox(height: 10),

            const Icon(Icons.lock_outline, size: 60, color: Color(0xFF2c5b34)),

            const SizedBox(height: 20),

            // Title
            Column(
              children: const [
                Text(
                  'Mot de passe',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2c5b34),
                  ),
                ),
                Text(
                  'oublié?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Pas de soucis, nous vous enverrons des instructions pour réinitialiser",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 30),

            // Green background with form
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 120,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2c5b34),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-mail',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  // Email input
                  TextField(
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Color(0xFF2c5b34)),
                    decoration: InputDecoration(
                      hintText: "entrer votre adresse e-mail",
                      hintStyle: const TextStyle(color: Colors.black54),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFF2c5b34),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Reset button (stylized)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: btnSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade100,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Réinitialiser votre mot de passe",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Retour à la connexion
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      ),
                      child: const Text(
                        "Retour à la connexion",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Icon at the bottom (like the image)
                  const Center(
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void btnSubmit() {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(
        Globs.appName,
        "Veuillez entrer une adresse e-mail valide.",
        () {},
      );
      return;
    }

    endEditing();

    serviceCallForgotRequest({"email": txtEmail.text});
  }

  void serviceCallForgotRequest(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(
      parameter,
      SVKey.svForgotPasswordRequest,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if (responseObj[KKey.status] == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPView(email: txtEmail.text),
            ),
          );
        } else {
          mdShowAlert(
            Globs.appName,
            responseObj[KKey.message] as String? ??
                "Échec de la réinitialisation.",
            () {},
          );
        }
      },
      failure: (err) async {
        Globs.hideHUD();
        mdShowAlert(Globs.appName, err.toString(), () {});
      },
    );
  }
}
