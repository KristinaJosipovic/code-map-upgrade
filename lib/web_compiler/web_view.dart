import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:code_map/user_authentication/not_logged_in_screen.dart';

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
      ) : NotLoggedInScreen(color: widget.color);

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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
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
