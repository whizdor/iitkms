import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:iitkms/helper/helper_function.dart';
import 'package:iitkms/pallete.dart';
import 'package:iitkms/screens/Home_Page.dart';
import 'package:iitkms/screens/Login_Page.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';
import 'package:iitkms/widgets/SnackBar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Center(
                  child: Form(
                      key: formKey,
                      child: Column(children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Image.asset('assets/images/logo.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: 'BrunoAce',
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'DESIGN. ',
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                  text: 'BUILD. ',
                                  style: TextStyle(color: Colors.red)),
                              TextSpan(
                                  text: 'RACE.',
                                  style: TextStyle(color: Colors.white)),
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
                        const Text('Register New User',
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
                                  labelText: "Full Name",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  fullName = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Name cannot be empty";
                                }
                              },
                            )),
                        const SizedBox(
                          height: 20,
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
                              "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                      ])),
                ),
              ));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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

  // register() async {
  //   // if (formKey.currentState!.validate()) {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   await authService
  //       .registerUserWithEmailandPassword(fullName, email, password)
  //       .then((value) {
  //     // if (value == true) {
  //     // saving the shared preference state
  //     // await HelperFunctions.saveUserLoggedInStatus(true);
  //     // await HelperFunctions.saveUserEmailSF(email);
  //     // await HelperFunctions.saveUserNameSF(fullName);
  //     // nextScreenReplace(context, const HomePage());
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //     // } else {
  //     showSnackbar(context, Colors.red, value);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }
}
