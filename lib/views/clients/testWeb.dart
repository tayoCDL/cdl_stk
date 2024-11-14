import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CDLConnect extends StatefulWidget {
  @override
  _CDLConnectState createState() => _CDLConnectState();
}

class _CDLConnectState extends State<CDLConnect> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CDL Connect'),
      ),
      body: WebView(

        initialUrl: 'about:blank', // Load a blank page initially
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
          loadScript();
        },
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'FlutterBridge',
            onMessageReceived: (JavascriptMessage message) {
              // Handle messages from JavaScript
              if (message.message == 'onSuccess') {
                // Handle success event
                print('Success event received from JavaScript');
              } else if (message.message == 'onError') {
                // Handle error event
                print('Error event received from JavaScript');
              } else if (message.message == 'onClose') {
                // Handle close event
                print('Close event received from JavaScript');
              }
            },
          ),
        },
      ),
    );
  }

  void loadScript() {
    final script = '''
      const script = document.createElement('script');
      script.src = 'https://bnplv2.creditdirect.ng/bvn-kyc-v1.js';
      script.onload = function() {
        const bvnVerificationInline = BVNVerificationInline({
          bvn: "22222222281", // Replace with your desired BVN
          onSuccess: function() {
            FlutterBridge.postMessage('onSuccess');
          },
          onError: function() {
            FlutterBridge.postMessage('onError');
          },
          onClose: function() {
            FlutterBridge.postMessage('onClose');
          },
        });
        bvnVerificationInline.openIframe();
      };
      document.body.appendChild(script);
    ''';
    _webViewController.evaluateJavascript(script);
  }
}


