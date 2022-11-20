import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  String link;

  WebViewScreen(this.link);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> webController =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffF9C303),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("Zaphry Payment"),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: "Back to Zaphry",
            ),
          ],
        ),
        body: WebView(
          initialUrl: widget.link,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
