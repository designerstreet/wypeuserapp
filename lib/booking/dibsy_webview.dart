import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wype_user/payment/payment_response.dart';
import 'package:wype_user/model/booking.dart';

import '../constants.dart';

class DibsyWebview extends StatefulWidget {
  String url;
  String id;
  double amount;
  BookingModel? booking;
  bool saveLocation;
  DibsyWebview(
      {super.key,
      required this.url,
      required this.id,
      required this.amount,
      required this.saveLocation,
      this.booking});

  @override
  State<DibsyWebview> createState() => _DibsyWebviewState();
}

class _DibsyWebviewState extends State<DibsyWebview> {
  late final WebViewController _controller;

  setWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://www.example.com')) {
              navigation(
                  context,
                  PaymentResponse(
                    id: widget.id,
                    booking: widget.booking,
                    amount: widget.amount,
                    saveLocation: widget.saveLocation,
                  ),
                  true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void initState() {
    super.initState();
    setWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: _controller),
    );
  }
}
