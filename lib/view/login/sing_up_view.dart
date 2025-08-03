import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food2/common/color_extension.dart';
import 'package:food2/view/login/login_view.dart';
import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common/extension.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF2c5b34),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.more_horiz, color: Colors.white, size: 28),
                  SizedBox(height: 12),
                  Text(
                    'Créons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'votre compte',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInputField(Icons.person, "Votre nom", txtName),
                  const SizedBox(height: 16),
                  _buildInputField(Icons.email, "adresse e-mail", txtEmail),
                  const SizedBox(height: 16),
                  _buildInputField(
                    Icons.lock,
                    "Mot de passe",
                    txtPassword,
                    isObscure: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    Icons.lock,
                    "Confirmez votre mot de passe",
                    txtConfirmPassword,
                    isObscure: true,
                  ),
                  const SizedBox(height: 16),

                  // Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            acceptTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "J’accepte les "),
                              TextSpan(
                                text: "conditions générales d’utilisation",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2c5b34),
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sign up button
                  ElevatedButton(
                    onPressed: () => btnSignUp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2c5b34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "s'inscrire",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "vous avez déjà un compte? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        },
                        child: const Text(
                          "Connexion",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2c5b34),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2c5b34)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF2c5b34)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF2c5b34)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF2c5b34), width: 2),
        ),
      ),
    );
  }

  void btnSignUp() {
    if (txtName.text.isEmpty) {
      mdShowAlert(Globs.appName, "Veuillez entrer votre nom.", () {});
      return;
    }
    if (!txtEmail.text.isEmail) {
      mdShowAlert(
        Globs.appName,
        "Veuillez entrer une adresse e-mail valide.",
        () {},
      );
      return;
    }
    if (txtPassword.text.length < 6) {
      mdShowAlert(
        Globs.appName,
        "Le mot de passe doit contenir au moins 6 caractères.",
        () {},
      );
      return;
    }
    if (txtPassword.text != txtConfirmPassword.text) {
      mdShowAlert(
        Globs.appName,
        "Les mots de passe ne correspondent pas.",
        () {},
      );
      return;
    }
    if (!acceptTerms) {
      mdShowAlert(
        Globs.appName,
        "Vous devez accepter les conditions d'utilisation.",
        () {},
      );
      return;
    }

    endEditing();

    serviceCallSignUp({
      "name": txtName.text,
      "email": txtEmail.text,
      "password": txtPassword.text,
      "push_token": "",
      "device_type": Platform.isAndroid ? "A" : "I",
    });
  }

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(
      parameter,
      SVKey.svSignUp,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if (responseObj[KKey.status] == "1") {
          Navigator.pop(context);
        } else {
          mdShowAlert(
            Globs.appName,
            responseObj[KKey.message] as String? ?? "Échec de l'inscription",
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
