import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:iitkms/helper/firebase_api.dart';
import 'package:iitkms/helper/firebase_file.dart';
import 'package:iitkms/pallete.dart';
import 'package:iitkms/screens/Home_Page.dart';
import 'package:iitkms/screens/Login_Page.dart';
import 'package:iitkms/screens/Upload_Page.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';

class DonwloadPage extends StatefulWidget {
  String userName;
  String email;
  String subsystem;
  String level;
  DonwloadPage(
      {Key? key,
      required this.email,
      required this.userName,
      required this.subsystem,
      required this.level})
      : super(key: key);
  @override
  State<DonwloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DonwloadPage> {
  late Future<List<FirebaseFile>> futureFiles;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    String usrname = widget.userName;
    String ss = widget.subsystem;
    futureFiles = FirebaseAPI.listAll("$ss/$usrname/");
  }

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
                onTap: () {
                  nextScreen(
                      context,
                      UploadPage(
                        userName: widget.userName,
                        email: widget.email,
                        subsystem: widget.subsystem,
                        level: widget.level,
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: Text("Upload File",
                    style: GoogleFonts.athiti(
                        color: Colors.white, fontSize: 20.0))),
            ListTile(
                onTap: () {},
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: Text("Download File",
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/black-marble-texture-background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<List<FirebaseFile>>(
            future: futureFiles,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text("Some Error occoured"));
                  } else {
                    final files = snapshot.data!;
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildHeader(files.length),
                        const SizedBox(
                          height: 12,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];

                              return buildFile(context, file);
                            },
                          ),
                        )
                      ],
                    ));
                  }
              }
            },
          )),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        title: Text(file.name,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.file_download,
            color: Colors.white,
          ),
          onPressed: () async {
            print(file.url);
            html.AnchorElement anchorElement =
                new html.AnchorElement(href: file.url);
            anchorElement.download = file.url;
            anchorElement.click();
            // FirebaseAPI.downloadFileURM(file.url);
            // final snackBar = SnackBar(content: Text("Donwloaded"));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      );
  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.white,
        leading: Container(
          child: Text(
            "$length File(s) in Storage",
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      );
}
