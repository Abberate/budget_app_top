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
  bool isSignIn = false;
  bool isObscure = true;
  var logger = Logger();

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> isSignedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignIn = false;
      } else {
        isSignIn = true;
      }
      notifyListeners();
    });
  }

  //logout function
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  //Authentication
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d("Registration successfull"))
        .onError((error, strackTrace) {
      logger.d("Registration error $error");
      DialogBox(
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
      DialogBox(
        context,
        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
      );
    });
  }

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d("Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError(
              (error, stackTrace) => DialogBox(
                context,
                error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
              ),
            );

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    await _auth.signInWithCredential(credential).then((onValue) {
      logger.d("Google Sign in successful");
    }).onError((error, stackTrace) {
      logger.d("Google Sign in error $error");
      DialogBox(
        context,
        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''),
      );
    });
  }

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String nameField = "";
    String amountField = "";

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
                validator: (value) {
                  if (value.toString().isEmpty || value == null) {
                    return "Required";
                  }
                  return null;
                },
                save: (value) {
                  nameField = value!;
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                digitOnly: true,
                validator: (value) {
                  if (value.toString().isEmpty || value == null) {
                    return "Required";
                  }
                  return null;
                },
                save: (value) {
                  amountField = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
              splashColor: Colors.grey,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.0),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  await userCollection
                      .doc(_auth.currentUser!.uid)
                      .collection("expenses")
                      .add({"name": nameField, "amount": amountField}).then(
                          (value) {
                    logger.d("Expense added");
                  }).onError((error, stackTrace) {
                    logger.d("Add Expense Error = $error");
                    return DialogBox(context, error.toString());
                  });
                  Navigator.pop(context);
                }
              },
              child: Poppins(text: "Save", size: 15.0, color: Colors.white))
        ],
      ),
    );
  }

  Future addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String nameField = "";
    String amountField = "";

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
                validator: (value) {
                  if (value.toString().isEmpty || value == null) {
                    return "Required";
                  }
                  return null;
                },
                save: (value) {
                  nameField = value!;
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                digitOnly: true,
                validator: (value) {
                  if (value.toString().isEmpty || value == null) {
                    return "Required";
                  }
                  return null;
                },
                save: (value) {
                  amountField = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
              splashColor: Colors.grey,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.0),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  await userCollection
                      .doc(_auth.currentUser!.uid)
                      .collection("incomes")
                      .add({"name": nameField, "amount": amountField}).then(
                          (value) {
                    logger.d("Income added");
                  }).onError((error, stackTrace) {
                    logger.d("Add income Error = $error");
                    return DialogBox(context, error.toString());
                  });
                  Navigator.pop(context);
                }
              },
              child: Poppins(text: "Save", size: 15.0, color: Colors.white))
        ],
      ),
    );
  }

  void expensesStream() {
    userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .snapshots()
        .listen(
      (expensesSnapshot) {
        expensesName.clear();
        expensesAmount.clear();
        for (var expense in expensesSnapshot.docs) {
          expensesName.add(expense["name"]);
          expensesAmount.add(expense["amount"]);
        }
        notifyListeners();
      },
    );
  }

  void incomesStream() {
    userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .snapshots()
        .listen(
      (incomesSnapshot) {
        incomesName.clear();
        incomesAmount.clear();
        for (var income in incomesSnapshot.docs) {
          incomesName.add(income["name"]);
          incomesAmount.add(income["amount"]);
        }
        notifyListeners();
      },
    );
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
