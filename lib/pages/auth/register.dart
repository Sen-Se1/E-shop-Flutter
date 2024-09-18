import 'package:e_comerce/pages/auth/login.dart';
import 'package:e_comerce/service/auth_service.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  String password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10.0),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD20686), Color(0xFF6C0345)],
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC6B19),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create an account!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFFF8DC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/backgroundPic.png', // Ensure this path is correct
                  fit: BoxFit.cover,
                ),
                Container(
                  color: const Color(0xFFFFBF00).withOpacity(0.5),
                ),
                SingleChildScrollView(
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 120),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "UserName...",
                                    suffixIcon: const Icon(Icons.person,
                                        color: Colors.black12),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      userName = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Username cannot be empty";
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:25),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "Email...",
                                    suffixIcon: const Icon(Icons.email_outlined,
                                        color: Colors.black12),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                  validator: (val) {
                                    return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                  hintText: "Password...",
                                  suffixIcon: const Icon(Icons.lock_outline,
                                      color: Colors.black12),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            child: GestureDetector(
                              onTap: register,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: const Color(0xff6C0345),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.robotoCondensed(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: GoogleFonts.robotoCondensed(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21),
                              ),
                              Text.rich(
                                // Wrap TextSpan in Text.rich
                                TextSpan(
                                  text: "Login now",
                                  style: GoogleFonts.robotoCondensed(
                                    textStyle: const TextStyle(
                                      color: Color(0xff6C0345),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        nextScreen(context, const LoginPage()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(userName, email, password)
          .then((value) async {
        if (value == true) {
          showSnackbar(context, Colors.green, "Registration successful! Please log in.");
          nextScreenRemove(context, const LoginPage());
        } else {
          showSnackbar(context, Colors.red, value ?? "Registration failed. Please try again.");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

}
