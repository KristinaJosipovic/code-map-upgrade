import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCompiler extends StatefulWidget {
  final String techName;
  final String color;
  const WebViewCompiler(this.techName, this.color, {super.key});

  @override
  State<WebViewCompiler> createState() => _WebViewCompilerState();
}

class _WebViewCompilerState extends State<WebViewCompiler> {
  late final WebViewController controller;
  var technologies = FirebaseFirestore.instance.collection("Tehnologije");
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController();

    Future.delayed(Duration.zero, () async {
      controller.loadRequest(Uri.parse(await getTechURL()));
    });
    checkIfLogin();
  }

  Future<String> getTechURL() async {
    var compilerURL = await technologies.where(
        "naziv", isEqualTo: widget.techName
    ).get();

    return compilerURL.docs.first['kompajler'];
  }

  @override
  Widget build(BuildContext context) {
      return isLogin ? Scaffold(
        body: MyWebView(controller: controller),
      ) : Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Za korištenje ove opcije morate biti prijavljeni!\n\nŽelite li se prijaviti?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Color(int.parse(widget.color)),
                        borderRadius: BorderRadius.circular(5),
                       // border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Prijavite se",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Medium',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key, required this.controller});

  final WebViewController controller;
  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
    // Modify from here...
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
    // ...to here.
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
