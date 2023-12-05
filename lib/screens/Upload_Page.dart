import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:iitkms/pallete.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPage extends StatefulWidget {
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  double progress = 0.0;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // final filetest = await openFile();
                    // final filename = filetest?.path;
                    // final Uint8List? file = await filetest?.readAsBytes();
                    // File filek = File(filetest!.path);
                    // String name = filek.files.first.name;
                    // print(filename);

                    if (result != null) {
                      Uint8List? file = result.files.first.bytes;
                      String fileName = result.files.first.name;
                      print("HI");
                      UploadTask task = FirebaseStorage.instance
                          .ref()
                          .child("files/$fileName")
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
                    "Upload File to Firebase Storage",
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
