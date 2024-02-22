import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        body: Container(
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
                                text: 'BUILD. ',
                                style: TextStyle(color: Colors.red)),
                            TextSpan(
                                text: 'RACE.',
                                style: new TextStyle(color: Colors.white)),
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
                            Text('Login to your account',
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
                                      enabledBorder: const OutlineInputBorder(
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
                                      focusedErrorBorder: OutlineInputBorder(
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
                                      enabledBorder: const OutlineInputBorder(
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
                                      focusedErrorBorder: OutlineInputBorder(
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
                                      prefixIcon: Icon(Icons.lock,
                                          color: Colors.white)),
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
                            ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: Center(
                                    child: Row(
                                  children: [
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
                                          fixedSize: const Size(190, 55),
                                        ),
                                        child: Text(
                                          "LOG IN",
                                          style: GoogleFonts.robotoMono(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          login();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
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
                                          fixedSize: const Size(190, 55),
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
                                          nextScreen(
                                              context, const RegisterPage());
                                        },
                                      ),
                                    )
                                  ],
                                ))),
                          ])),
                      const SizedBox(
                        height: 400,
                      ),
                    ])),
              ),
            )));
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
          await HelperFunctions.saveUserSubSystemSF(snapshot.docs[0]['sub']);
          await HelperFunctions.saveUserLevelSF(snapshot.docs[0]['level']);
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
