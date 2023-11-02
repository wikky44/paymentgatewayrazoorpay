import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amt,String name,String item,String ph,String email) async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': amt*100,
      'name': '$name',
      'description': '$item',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '$ph', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  TextEditingController name=TextEditingController();
  TextEditingController dis=TextEditingController();
  TextEditingController amt=TextEditingController();
  TextEditingController ph=TextEditingController();
  TextEditingController email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razorpay Sample App'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "name"
                  ),
                ),
                TextFormField(
                  controller: dis,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "discription"
                  ),
                ),
                TextFormField(
                  controller: amt,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "amt"
                  ),
                ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "email"
                  ),
                ),
                TextFormField(
                  controller: ph,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "phone"
                  ),
                ),
                ElevatedButton(onPressed: (){
                  openCheckout(int.parse(amt.text.toString()), "${name.text}", "${dis.text}", "${ph.text}", "${email.text}");
                }, child: Text('Open')),
              ],
            )),
      ),
    );
  }






}