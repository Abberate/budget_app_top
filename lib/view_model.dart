import 'package:budget_app/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  bool isSignIn = false;
  bool isObscure = true;
  var logger = Logger();

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> isSignedIn() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignIn = false;
      } else {
        isSignIn = true;
      }
    });

    notifyListeners();
  }

  //logout function
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Authentication
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d("Registration successfull"))
        .onError((error, strackTrace) {
      logger.d("Registration error $error");
      DialogueBox(
        context,
        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
      );
    });
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d("Login successfull Ok"))
        .onError((error, stackTrace) {
      logger.d("Login error $error");
      DialogueBox(
        context,
        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
      );
    });
  }

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogueBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d("Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> signInWithGoogleWebMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn()
        .onError((error, stackTrace) => DialogueBox(
              context,
              error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
            ));

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    await _auth.signInWithCredential(credential).then((onValue) {
      logger.d("Google Sign in successful");
    }).onError((error, stackTrace) {
      logger.d("Google Sign in error $error");
      DialogueBox(
        context,
        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
      );
    });
  }

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10.0),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                  text: "Name",
                  containerWidth: 130.0,
                  hintText: "Name",
                  controller: controllerName,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Required";
                    }
                  }),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                controller: controllerAmount,
                digitOnly: true,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Required";
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
              child: Poppins(text: "Save", size: 15.0, color: Colors.white),
              splashColor: Colors.grey,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.0),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  userCollection.doc();
                }
              })
        ],
      ),
    );
  }
}
