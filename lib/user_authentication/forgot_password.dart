import 'package:code_map/user_authentication/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Email za ponovo postavljanje lozinke je poslan!",
            style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins-Medium',),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Ne postoji korisnik za unesenu email adresu",
              style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins-Medium',),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Column(
          children: [
           const SizedBox(
              height: 70.0,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: const Text(
                "Oporavak lozinke",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Medium'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Unesite mail",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Medium'),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white70, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Molimo vas unesite email';
                                  }
                                  return null;
                                },
                                controller: mailcontroller,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontSize: 18.0, color: Colors.white, fontFamily: 'Poppins-Medium'),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                      size: 30.0,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                if(_formkey.currentState!.validate()){
                                  setState(() {
                                    email=mailcontroller.text;
                                  });
                                  resetPassword();
                                }
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    "Pošaljite",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins-Medium'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Nemate račun?",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white,
                                  fontFamily: 'Poppins-Medium'),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignUp()));
                                  },
                                  child: const Text(
                                    "Napravi",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                     fontFamily: 'Poppins-Medium'),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
