import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginViewMobile extends HookConsumerWidget {
  const LoginViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            EmailAndPasswordFields(),
            SizedBox(
              height: 30.0,
            ),
            RegisterAndLogin(),
            SizedBox(
              height: 30.0,
            ),
            GoogleSignInButton()
          ],
        ),
      ),
    ));
  }
}
