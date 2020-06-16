import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/networking/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

  String AUTH_KEY= "";


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
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
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