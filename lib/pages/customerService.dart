import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';

class Customerservice extends StatefulWidget {
  const Customerservice({super.key});

  @override
  State<Customerservice> createState() => _CustomerserviceState();
}

class _CustomerserviceState extends State<Customerservice> {
  String userName = '';
  String email = '';

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
          "Customer Service",
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
      body: Tawk(
        directChatLink: Constants.directChatLink,
        visitor: TawkVisitor(
          name: userName.toString(),
          email: email.toString(),
        ),
        onLoad: () {
          print('Hello Tawk! $userName $email');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: Center(
          child: CircularProgressIndicator(color: Constants().primaryColor),
        ),
      ),
    );
  }
}
