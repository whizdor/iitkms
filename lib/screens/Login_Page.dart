import 'package:flutter/material.dart';
import 'package:iitkms/pallete.dart';
import 'package:iitkms/screens/Home_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iitkms/screens/Register_Page.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:iitkms/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:iitkms/helper/helper_function.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';
import 'package:iitkms/widgets/SnackBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Form(
            key: formKey,
            child: Column(children: [
              const SizedBox(
                height: 70,
              ),
              Image.asset('assets/images/logo.png'),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'BrunoAce',
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'DESIGN. ',
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: 'BUILD. ', style: TextStyle(color: Colors.red)),
                    TextSpan(
                        text: 'RACE.',
                        style: new TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text('Welcome!',
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 40,
                    color: Colors.white,
                  )),
              const Text('Login to your account',
                  style: TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 20,
                    color: Colors.white,
                  )),
              const SizedBox(
                height: 30,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },

                    // check tha validation
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Pallete.gradient1,
                      Pallete.gradient2,
                      Pallete.gradient3,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    fixedSize: const Size(395, 55),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  onPressed: () {
                    login();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Pallete.gradient1,
                      Pallete.gradient2,
                      Pallete.gradient3,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    fixedSize: const Size(395, 55),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  onPressed: () {
                    nextScreen(context, const RegisterPage());
                  },
                ),
              ),
            ])),
      ),
    ));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
