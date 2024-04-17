import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/home_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:code_map/articles/article_page.dart';

class WebViewCompiler extends StatefulWidget {
  final String techName;
  const WebViewCompiler(this.techName, {super.key});

  @override
  State<WebViewCompiler> createState() => _WebViewCompilerState();
}

class _WebViewCompilerState extends State<WebViewCompiler> {
  late final WebViewController controller;
  var technologies = FirebaseFirestore.instance.collection("Tehnologije");

  @override
  void initState() {
    super.initState();
    controller = WebViewController();

    Future.delayed(Duration.zero, () async {
      controller.loadRequest(Uri.parse(await getTechURL()));
    });
  }

  Future<String> getTechURL() async {
    var compilerURL = await technologies.where(
        "naziv", isEqualTo: widget.techName
    ).get();

    return compilerURL.docs.first['kompajler'];
    //return "https://stackoverflow.com/questions/51901002/is-there-a-way-to-load-async-data-on-initstate-method";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: MyWebView(controller: controller),

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
