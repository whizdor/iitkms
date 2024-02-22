import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
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
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/black-marble-texture-background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                        key: formKey,
                        child: Column(children: [
                          const SizedBox(
                            height: 30,
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
                            height: 30,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              padding: EdgeInsets.all(30),
                              child: Column(children: [
                                Text('WELCOME',
                                    style: GoogleFonts.firaMono(
                                        color: Colors.white,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold)),
                                Text('Register New User',
                                    style: GoogleFonts.firaMono(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 30,
                                ),
                                ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 400),
                                    child: TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: "Name",
                                          labelStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                          errorStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.white,
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
                                    constraints:
                                        const BoxConstraints(maxWidth: 400),
                                    child: TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: "Email",
                                          labelStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                          errorStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.white,
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
                                    constraints:
                                        const BoxConstraints(maxWidth: 400),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: textInputDecoration.copyWith(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: "Password",
                                          labelStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                          errorStyle: GoogleFonts.firaMono(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.white,
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
                                  decoration: const BoxDecoration(
                                    // gradient: const LinearGradient(
                                    //   colors: [
                                    //     Pallete.gradient1,
                                    //     Pallete.gradient2,
                                    //     Pallete.gradient3,
                                    //   ],
                                    //   begin: Alignment.bottomLeft,
                                    //   end: Alignment.topRight,
                                    // ),
                                    color: Colors.white,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      fixedSize: const Size(390, 55),
                                    ),
                                    child: Text(
                                      "REGISTER",
                                      style: GoogleFonts.robotoMono(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      register();
                                    },
                                  ),
                                ),
                              ])),
                          const SizedBox(
                            height: 400,
                          ),
                        ])),
                  ),
                )));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              fullName, email, password, "notassigned", "notassigned")
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
