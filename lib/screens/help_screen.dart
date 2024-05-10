import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.green],
            ),
          ),
        ),
        title: const Text(
          "Code <map>",
          style: TextStyle(
            fontFamily: 'Poppins-Medium',
            color: Colors.black,
            fontSize: 23,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ime i prezime:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'John Doe',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Email:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'example@example.com',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Predmet:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Poruka:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  String name = _nameController.text.trim();
                  String email = _emailController.text.trim();
                  String subject = _subjectController.text.trim();
                  String message = _bodyController.text.trim();

                  if (name.isNotEmpty && email.isNotEmpty && subject.isNotEmpty && message.isNotEmpty) {
                    await sendEmail(
                    name: name,
                    email: email,
                    subject: subject,
                    message: message,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mail je uspješno poslan.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Sva polja moraju biti popunjena.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
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
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                          "Pošaljite",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins-Medium',),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future sendEmail({
  required String name,
  required String email,
  required String subject,
  required String message,
}) async{
  const serviceId = 'service_g0u4oyc';
  const templateId = 'template_fyp6pwx';
  const userId = '5LxYN8QOr5hllgmya';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode( {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_email': email,
        'user_subject': subject,
        'user_message': message,
      }
    }),
  );
}