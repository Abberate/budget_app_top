import 'package:budget_app/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Poppins extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;
  const Poppins(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}

DialogBox(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.all(32.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.0),
        side: BorderSide(color: Colors.black, width: 2.0),
      ),
      title: Poppins(text: title, size: 20.0),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.black,
          child: Poppins(
            text: 'Okay',
            size: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class TextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final digitOnly;
  final String? Function(String?)
      validator; // on peut retirer String? Function(String?)
  final void Function(String?) save; // on peut retirer void Function(String?)
  const TextForm({
    super.key,
    required this.text,
    required this.containerWidth,
    required this.hintText,
    required this.validator,
    required this.save,
    this.digitOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Poppins(text: text, size: 13.0),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            validator: validator,
            onSaved: save,
            inputFormatters: digitOnly != null
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                hintStyle: GoogleFonts.poppins(fontSize: 13.0),
                hintText: hintText),
          ),
        )
      ],
    );
  }
}

TextEditingController _emailField = TextEditingController();
TextEditingController _passwordField = TextEditingController();

class EmailAndPasswordFields extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Column(
      children: [
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
      ],
    );
  }
}

class RegisterAndLogin extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
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
          style: GoogleFonts.poppins(color: Color(0xFF6C63FF), fontSize: 15.0),
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
    );
  }
}

class GoogleSignInButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SignInButton(
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
        });
  }
}

class DrawerExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF6C63FF), width: 1.0),
              ),
              child: CircleAvatar(
                radius: 180.0,
                backgroundColor: Colors.white,
                child: Image(
                  height: 100.0,
                  image: AssetImage("assets/logo.png"),
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          MaterialButton(
            color: Color(0xFF6C63FF),
            height: 50.0,
            minWidth: 200.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 20.0,
            child: Poppins(
              text: "Logout",
              size: 20.0,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModelProvider.logout();
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  await launchUrl(Uri.parse("https://instagram.com"));
                },
                icon: SvgPicture.asset(
                  'assets/instagram.svg',
                  width: 35.0,
                  color: Color(0xFF6C63FF),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await launchUrl(Uri.parse("https://twitter.com"));
                },
                icon: SvgPicture.asset(
                  'assets/twitter.svg',
                  width: 35.0,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddExpense extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 50.0,
      width: 180.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.grey,
          backgroundColor: Color(0xFF6C63FF),
          iconColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.0),
          ),
        ),
        label: Poppins(
          text: "Add Expense",
          size: 15.0,
          color: Colors.white,
        ),
        icon: Icon(
          Icons.add,
          size: 15.0,
          color: Colors.white,
        ),
        onPressed: () async {
          await viewModelProvider.addExpense(context);
        },
      ),
    );
  }
}

class AddIncome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 50.0,
      width: 180.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.grey,
          backgroundColor: Color(0xFF6C63FF),
          iconColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.0),
          ),
        ),
        label: Poppins(
          text: "Add Income",
          size: 15.0,
          color: Colors.white,
        ),
        icon: Icon(
          Icons.add,
          size: 15.0,
          color: Colors.white,
        ),
        onPressed: () async {
          await viewModelProvider.addIncome(context);
        },
      ),
    );
  }
}

class TotalCalculation extends HookConsumerWidget {
  final size;
  TotalCalculation(this.size);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(text: "Budget left", size: size, color: Colors.white),
            Poppins(text: "Total expense", size: size, color: Colors.white),
            Poppins(text: "Total Incomes", size: size, color: Colors.white),
          ],
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Divider(
            color: Colors.white,
            indent: 40.0,
            endIndent: 40.0,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
                text: "${viewModelProvider.budgetLeft} CFA",
                size: size,
                color: Colors.white),
            Poppins(
                text: "${viewModelProvider.totalExpense} CFA",
                size: size,
                color: Colors.white),
            Poppins(
                text: "${viewModelProvider.totalIncome} CFA",
                size: size,
                color: Colors.white),
          ],
        )
      ],
    );
  }
}

class IncomeExpenseRowMobile extends HookConsumerWidget {
  final String name;
  final String amount;
  IncomeExpenseRowMobile({super.key, required this.name, required this.amount});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Poppins(
          text: name,
          size: 15.0,
          color: Color(0xFF6C63FF),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Poppins(
            text: amount,
            size: 15.0,
            color: Color(0xFF6C63FF),
          ),
        )
      ],
    );
  }
}

class IncomeExpenseRowWeb extends HookConsumerWidget {
  final String name;
  final String amount;
  IncomeExpenseRowWeb({super.key, required this.name, required this.amount});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Poppins(
          text: name,
          size: 15.0,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Poppins(
            text: amount,
            size: 15.0,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
