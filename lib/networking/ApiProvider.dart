import 'dart:math';

import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/networking/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

  String AUTH_KEY= "";
  String USER_ID= "";
  String USER_NAME= "";
  String USER_PHOTO ="";
  String USER_MOBILE ="";
  String USER_EMAIL ="";
  int DOC_HOME_VISIT =0;


  final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";

  Future<LoginResponse> performLogin(String email, String password) async {
    final http.Response response = await http.post(
      _baseUrl + 'login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      LoginResponse loginResponse =LoginResponse.fromJson(json.decode(response.body));
      USER_NAME = loginResponse.userInfo.name;
      USER_PHOTO = loginResponse.userInfo.photo;
      USER_MOBILE = loginResponse.userInfo.phone;
      USER_EMAIL = loginResponse.userInfo.email;
      showThisToast("phoyo link "+USER_PHOTO);
      return loginResponse;
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<dynamic> performLoginSecond(String email, String password) async {
    final http.Response response = await http.post(
      _baseUrl + 'login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      LoginResponse loginResponse =LoginResponse.fromJson(json.decode(response.body));
      USER_NAME = loginResponse.userInfo.name;
      USER_PHOTO = loginResponse.userInfo.photo;
      USER_MOBILE = loginResponse.userInfo.phone;
      USER_EMAIL = loginResponse.userInfo.email;
      showThisToast("phoyo link "+USER_PHOTO);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<dynamic> performAppointmentSubmit(String patient_id,String dr_id,String problems, String phone, String name ,String chamber_id,String date, String status, String type) async {
    final http.Response response = await http.post(
      _baseUrl + 'add-appointment-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'patient_id': patient_id,
        'dr_id': dr_id,
        'problems':problems,
        'phone': phone,
        'name':name,
        'chamber_id': chamber_id,
        'date':date,
        'status': status,
        'type':type,
      }),
    );
    showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LoginResponse> fetchDepartList(String email, String password) async {
    final http.Response response = await http.post(
      _baseUrl + 'department-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },

    );
    showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
     // return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<dynamic> updateDisplayName(String name) async {
    final http.Response response = await http.post(
      _baseUrl + 'update-user-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
      'name': name,
      'user_id':USER_ID
    }),

    );
   // showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
     // return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
Future<dynamic> addDiseasesHistory(String name,String startdate,String status) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-disease-record',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(<String, String>{
      'patient_id': USER_ID,
      'disease_name':name,
      'first_notice_date':startdate,
      'status':status
    }),

  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception((response.statusCode).toString());
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
