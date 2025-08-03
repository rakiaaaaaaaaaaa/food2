import 'package:flutter/material.dart';
import 'package:food2/common/color_extension.dart';
import 'package:food2/common/extension.dart';
import 'package:food2/common/globs.dart';
import 'package:food2/view/login/rest_password_view.dart';
import 'package:food2/view/login/sing_up_view.dart';
import 'package:food2/view/on_boarding/on_boarding_view.dart';
import '../../common/service_call.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f4c2e),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.more_horiz, color: Colors.white, size: 26),
            const SizedBox(height: 16),
            Image.asset("assets/img/app_logo.png", width: 140, height: 140),
            const SizedBox(height: 16),
            const Text(
              "TO GOOD TO WASTE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildInputField(
                    icon: Icons.person,
                    hint: "Email ou numéro de téléphone",
                    controller: txtEmail,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.lock,
                    hint: "Mot de passe",
                    controller: txtPassword,
                    isObscure: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResetPasswordView(),
                          ),
                        );
                      },
                      child: const Text(
                        "Mot de passe oublié",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildBottomPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF2e6140),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => btnLogin(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2c5b34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(double.infinity, 50),
              elevation: 5,
              shadowColor: Colors.black54,
            ),
            child: const Text("Connexion", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
          const Text("ou", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpView()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFc7efcf), Color(0xFFa6e3a1)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "créer un nouveau compte",
                style: TextStyle(
                  color: Color(0xFF2c5b34),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void btnLogin() {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtPassword.text.length < 6) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    endEditing();

    serviceCallLogin({
      "email": txtEmail.text,
      "password": txtPassword.text,
      "push_token": "",
    });
  }

  void serviceCallLogin(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(
      parameter,
      SVKey.svLogin,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if (responseObj[KKey.status] == "1") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingView()),
            (route) => false,
          );
        } else {
          mdShowAlert(
            Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail,
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
