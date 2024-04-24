import 'package:code_map/home_page.dart';
import 'package:code_map/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && nameController.text!=""&& mailController.text!="") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Uspješno ste registrovani",
          style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Medium'),
        )));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Šifra je preslaba");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Šifra je preslaba",
                style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins-Medium'),
              )));
        } else if (e.code == "email-already-in-use") {
          print("Račun već postoji");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Korisnički račun već postoji",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/auth_icons/app_logo.png",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite ime';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ime",
                            hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf),
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Medium')),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite email adresu';
                          }
                          return null;
                        },
                        controller: mailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf),
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Medium')),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite lozinku';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,

                            hintText: "Lozinka",
                            hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf),
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Medium')),
             obscureText: true,  ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            email=mailController.text;
                            name= nameController.text;
                            password=passwordController.text;
                          });
                        }
                        registration();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top:20),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 30.0),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.blue, Colors.green],
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                child: Text(
                              "Registrujte se",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins-Medium'),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Već imate korisnički račun?",
                    style: TextStyle(
                        color: Color(0xFF8c8e98),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins-Medium')),
                const SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                  child: const Text(
                    "Prijava",
                    style: TextStyle(
                        color: Color(0xFF273671),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins-Medium'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
