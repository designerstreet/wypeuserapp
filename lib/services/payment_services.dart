import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/dibsy_res.dart';

Future<PaymentModel?> createPayment(double amount, String description) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $testKey',
  };
  var request =
      http.Request('POST', Uri.parse('https://api.dibsy.one/v2/payments'));
  request.body = json.encode({
    "amount": {"currency": "QAR", "value": amount.toStringAsFixed(2)},
    "description": description,
    "method": "creditcard",
    "redirectUrl": "http://www.example.com"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 201) {
    var finalRes = await http.Response.fromStream(response);
    var body = jsonDecode(finalRes.body);
    PaymentModel paymentRes = PaymentModel.fromJson(body);
    return paymentRes;
  } else {
    return null;
  }
}

Future<PaymentModel?> checkStatus(String id) async {
  var headers = {
    'Authorization': 'Bearer sk_test_63b66c8b26cd58f96f7e69d6c21781439169',
  };
  var request =
      http.Request('GET', Uri.parse('https://api.dibsy.one/v2/payments/$id'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var finalRes = await http.Response.fromStream(response);
    var body = jsonDecode(finalRes.body);
    PaymentModel paymentRes = PaymentModel.fromJson(body);
    return paymentRes;
  } else {
    return null;
  }
}
