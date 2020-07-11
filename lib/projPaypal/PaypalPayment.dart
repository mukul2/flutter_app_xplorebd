import 'dart:convert';
import 'dart:core';
import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/view/doctor/doctor_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';
import 'dart:io';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'config.dart';

final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  PaypalPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = payable_amount;
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = payable_amount;
    String subTotalAmount = payable_amount;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) async {
                  //  widget.onFinish(id);
                  //  Navigator.of(context).pop();
                  if (type == 'Prescription Service') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MakePrescriptionRequestWidget(
                                id, payable_amount, docID)));
                  } else if (type == '1 Month Subscription') {
                    DateTime selectedDate = DateTime.now();
                    String startDate = (selectedDate.year).toString() +
                        "-" +
                        (selectedDate.month).toString() +
                        "-" +
                        (selectedDate.day).toString();
                    DateTime endDate_ =
                        DateTime.now().add((Duration(days: 30)));
                    endDate_.add((Duration(days: 30)));
                    String endDate =
                        (DateTime.now().add((Duration(days: 30))).year)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 30))).month)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 30))).day)
                                .toString();

                    final http.Response response = await http.post(
                      _baseUrl + 'add_subscription_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': USER_ID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "1",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                      }),
                    );
                   // showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  } else if (type == '3 Month Subscription') {
                    DateTime selectedDate = DateTime.now();
                    String startDate = (selectedDate.year).toString() +
                        "-" +
                        (selectedDate.month).toString() +
                        "-" +
                        (selectedDate.day).toString();

                    selectedDate.add((Duration(days: 90)));
                    String endDate =
                        (DateTime.now().add((Duration(days: 90))).year)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 90))).month)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 90))).day)
                                .toString();

                    final http.Response response = await http.post(
                      _baseUrl + 'add_subscription_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': USER_ID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "3",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                      }),
                    );
                   // showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //  Navigator.of(context).pop();
                  } else if (type == '6 Month Subscription') {
                    DateTime selectedDate = DateTime.now();
                    String startDate = (selectedDate.year).toString() +
                        "-" +
                        (selectedDate.month).toString() +
                        "-" +
                        (selectedDate.day).toString();

                    selectedDate.add((Duration(days: 180)));
                    String endDate =
                        (DateTime.now().add((Duration(days: 180))).year)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 180))).month)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 180))).day)
                                .toString();
                    final http.Response response = await http.post(
                      _baseUrl + 'add_subscription_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': USER_ID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "6",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                      }),
                    );
                  //  showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                  } else if (type == '1 Year Subscription') {
                    DateTime selectedDate = DateTime.now();
                    String startDate = (selectedDate.year).toString() +
                        "-" +
                        (selectedDate.month).toString() +
                        "-" +
                        (selectedDate.day).toString();

                    selectedDate.add((Duration(days: 360)));
                    String endDate =
                        (DateTime.now().add((Duration(days: 360))).year)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 360))).month)
                                .toString() +
                            "-" +
                            (DateTime.now().add((Duration(days: 360))).day)
                                .toString();

                    final http.Response response = await http.post(
                      _baseUrl + 'add_subscription_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': USER_ID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "12",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                      }),
                    );
                    print(jsonEncode(<String, String>{
                      'patient_id': USER_ID,
                      'dr_id': docID,
                      'payment_status': "1",
                      'number_of_months': "12",
                      'payment_details': id,
                      'starts': startDate,
                      'amount': payable_amount,
                      'ends': endDate,
                    }));
                  //  showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  }else if (type == 'Chat'){
                    final http.Response response = await http.post(
                      _baseUrl + 'add_chat_appointment_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': USER_ID,
                        'dr_id': docID,
                        'amount': payable_amount,
                        'payment_details': id
                      }),
                    );
                   // showThisToast(response.statusCode.toString());
                    //popup count


                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                    String chatRoom = createChatRoomName(int.parse(USER_ID), int.parse(docID));
                    CHAT_ROOM = chatRoom;
                    print("chat room "+chatRoom);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                USER_ID,
                                USER_NAME,
                                USER_PHOTO,
                                docID,
                                docNAME,
                                docPhoto,
                                chatRoom)));

                  }
                });
              } else {
                // Navigator.of(context).pop();
              }
              //  Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}

class MakePrescriptionRequestWidget extends StatefulWidget {
  String tranactionID;

  String fees;

  String docID;

  MakePrescriptionRequestWidget(this.tranactionID, this.fees, this.docID);

  @override
  _MakePrescriptionRequestState createState() =>
      _MakePrescriptionRequestState();
}

class _MakePrescriptionRequestState
    extends State<MakePrescriptionRequestWidget> {
  final _formKey = GlobalKey<FormState>();
  String problem;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Prescription Request"),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Write your problems in detail and Doctor will send you prescription",
                  style: TextStyle(color: Color(0xFF34448c), fontSize: 17),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  initialValue: "",
                  validator: (value) {
                    problem = value;
                    if (value.isEmpty) {
                      return 'Write your Problems';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SizedBox(
                    height: 50,
                    width: double.infinity, // match_parent
                    child: RaisedButton(
                      color: Color(0xFF34448c),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          setState(() {
                            StandbyWid = Text("Please wait",
                                style: TextStyle(color: Colors.white));
                          });
                          final http.Response response = await http.post(
                            _baseUrl + 'add-prescription-request',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization': AUTH_KEY,
                            },
                            body: jsonEncode(<String, String>{
                              'patient_id': USER_ID,
                              'dr_id': widget.docID,
                              'payment_status': "1",
                              'problem': problem,
                              'payment_details': widget.tranactionID
                            }),
                          );
                        //  showThisToast(response.statusCode.toString());
                          //popup count

                          setState(() {
                            StandbyWid = Text("Prescription request success",
                                style: TextStyle(color: Colors.white));
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {}
                      },
                      child: StandbyWid,
                    )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
