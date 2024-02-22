import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:iitkms/pallete.dart';
import 'package:iitkms/screens/Download_Page.dart';
import 'package:iitkms/screens/Home_Page.dart';
import 'package:iitkms/screens/Login_Page.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';

class UploadPage extends StatefulWidget {
  String userName;
  String email;
  String subsystem;
  String level;
  UploadPage(
      {Key? key,
      required this.email,
      required this.userName,
      required this.subsystem,
      required this.level})
      : super(key: key);
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  double progress = 0.0;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "IITK Motorsports",
            style: TextStyle(
                fontFamily: 'BrunoAce',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27),
          )),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'BrunoAce',
                  fontSize: 15,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'DESIGN. ', style: TextStyle(color: Colors.white)),
                  TextSpan(
                      text: 'BUILD. ', style: TextStyle(color: Colors.red)),
                  TextSpan(
                      text: 'RACE.', style: new TextStyle(color: Colors.white)),
                ],
              ),
            )),
            const SizedBox(
              height: 15,
            ),
            Text(widget.userName,
                textAlign: TextAlign.center,
                style: GoogleFonts.athiti(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.group,
                color: Colors.white,
              ),
              title: Text("Chats",
                  style:
                      GoogleFonts.athiti(color: Colors.white, fontSize: 20.0)),
            ),
            ListTile(
                onTap: () {},
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: Text("Upload File",
                    style: GoogleFonts.athiti(
                        color: Colors.white, fontSize: 20.0))),
            ListTile(
                onTap: () {
                  nextScreen(
                      context,
                      DonwloadPage(
                        userName: widget.userName,
                        email: widget.email,
                        subsystem: widget.subsystem,
                        level: widget.level,
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: Text("Dowload File",
                    style: GoogleFonts.athiti(
                        color: Colors.white, fontSize: 20.0))),
            ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Log Out",
                              style: GoogleFonts.athiti(
                                  color: Colors.white, fontSize: 20.0)),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.exit_to_app),
                title: Text("Log Out",
                    style: GoogleFonts.athiti(
                        color: Colors.white, fontSize: 20.0))),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 500,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.grey,
                      Colors.white,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      Uint8List? file = result.files.first.bytes;
                      String fileName = result.files.first.name;
                      String usrname = widget.userName;
                      String ss = widget.subsystem;
                      UploadTask task = FirebaseStorage.instance
                          .ref()
                          .child("$ss/$usrname/$fileName")
                          .putData(file!);

                      task.snapshotEvents.listen((event) {
                        setState(() {
                          progress = ((event.bytesTransferred.toDouble() /
                                      event.totalBytes.toDouble()) *
                                  100)
                              .roundToDouble();

                          if (progress == 100) {
                            event.ref
                                .getDownloadURL()
                                .then((downloadUrl) => print(downloadUrl));
                          }

                          print(progress);
                        });
                      });
                    }
                  },
                  child: Text(
                    "Upload File to Personal Storage",
                    style: GoogleFonts.athiti(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 200.0,
                width: 200.0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 375),
                  child: progress == 100.0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Upload Complete',
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "$progress%",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 25.0),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
