import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitkms/helper/helper_function.dart';
import 'package:iitkms/screens/Download_Page.dart';
import 'package:iitkms/screens/Login_Page.dart';
import 'package:iitkms/screens/Search_Page.dart';
import 'package:iitkms/screens/Upload_Page.dart';
import 'package:iitkms/services/auth_services.dart';
import 'package:iitkms/services/database_services.dart';
import 'package:iitkms/widgets/Group_Tile.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';
import 'package:iitkms/widgets/SnackBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  String subsystem = "";
  String level = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserSubSystemFromSF().then((val) {
      setState(() {
        subsystem = val!;
      });
    });
    await HelperFunctions.getUserLevelFromSF().then((val) {
      setState(() {
        level = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(
                  Icons.search,
                ))
          ],
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
            Text(userName,
                textAlign: TextAlign.center,
                style: GoogleFonts.athiti(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            Text(subsystem,
                textAlign: TextAlign.center,
                style: GoogleFonts.athiti(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
            Text(level,
                textAlign: TextAlign.center,
                style: GoogleFonts.athiti(
                  color: Colors.white,
                  fontSize: 17.0,
                )),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
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
                        userName: userName,
                        email: email,
                        subsystem: subsystem,
                        level: level,
                      ));
                },
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
                        userName: userName,
                        email: email,
                        subsystem: subsystem,
                        level: level,
                      ));
                },
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
                          backgroundColor: Colors.black,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/black-marble-texture-background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: groupList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                "New Group?",
                textAlign: TextAlign.left,
                style: GoogleFonts.athiti(color: Colors.white, fontSize: 20.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: GoogleFonts.athiti(
                              color: Colors.white, fontSize: 20.0),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text(
                    "CANCEL",
                    style:
                        GoogleFonts.athiti(color: Colors.white, fontSize: 15.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group Created successfully!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text("CREATE",
                      style: GoogleFonts.athiti(
                          color: Colors.white, fontSize: 15.0)),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.black,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
