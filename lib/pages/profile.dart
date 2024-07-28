import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants().primaryColor,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            nextScreen(context, const NavbarPage());
          },
        ),
      ),
      backgroundColor: Constants().bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 160,
                    weight: 20,
                    color: Colors.grey,
                  ),
                  Text("Change Profile Picture"),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Profile Information",
              style: GoogleFonts.robotoCondensed(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "   Username",
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                Expanded(
                    flex: 5,
                    child: Text(
                      userName,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                const Expanded(
                    child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 21,
                )),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "   E-mail",
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                Expanded(
                    flex: 5,
                    child: Text(
                      email,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                const Expanded(
                    child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 21,
                )),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "   Password",
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                Expanded(
                    flex: 5,
                    child: Text(
                      "Change your Password",
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    )),
                const Expanded(
                    child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 21,
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
