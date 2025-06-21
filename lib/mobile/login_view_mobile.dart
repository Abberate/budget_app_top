import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginViewMobile extends HookConsumerWidget {
  const LoginViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _emailField = useTextEditingController();
    TextEditingController _passwordField = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight / 5.5,
            ),
            Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
              width: 210.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextFormField(
                controller: _emailField,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xFF6C63FF),
                    size: 30.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: 'Email',
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextFormField(
                controller: _passwordField,
                textAlign: TextAlign.center,
                obscureText: viewModelProvider.isObscure,
                obscuringCharacter: "⁕",
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      viewModelProvider.toggleObscure();
                    },
                    icon: Icon(
                      viewModelProvider.isObscure
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF6C63FF),
                      size: 30.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: "Password",
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //registration Button
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await viewModelProvider.createUserWithEmailAndPassword(
                          context, _emailField.text, _passwordField.text);
                    },
                    splashColor: Colors.grey,
                    color: Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Poppins(
                      text: "Register",
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  "Or",
                  style: GoogleFonts.poppins(
                      color: Color(0xFF6C63FF), fontSize: 15.0),
                ),
                SizedBox(width: 20.0),
                //Login button
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await viewModelProvider.signInWithEmailAndPassword(
                          context, _emailField.text, _passwordField.text);
                    },
                    splashColor: Colors.grey,
                    color: Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Poppins(
                      text: "Login",
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            SignInButton(
                buttonType: ButtonType.google,
                btnColor: Color(0xFF6C63FF),
                btnTextColor: Colors.white,
                buttonSize: ButtonSize.medium,
                onPressed: () async {
                  if (kIsWeb) {
                    await viewModelProvider.signInWithGoogleWeb(context);
                  } else {
                    await viewModelProvider.signInWithGoogleMobile(context);
                  }
                }),
          ],
        ),
      ),
    ));
  }
}
