import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/main.dart';

const API_URL = 'https://todoapp-api-pyq5q.ondigitalocean.app';
const API_KEY = '35292139-6b4b-4ef3-99c6-28b152695aad';

class apiGrejer {
  static Future<List<ListSpec>> nyItem(ListSpec aktivitet) async {
    Map<String, dynamic> json = ListSpec.toJson(aktivitet);
    var bodyText = jsonEncode(json);
    var svar = await http.post(
      Uri.parse('$API_URL/todos?key=$API_KEY'),
      body: bodyText,
      headers: {'Content-Type': 'application/json'},
    );
    bodyText = svar.body;
    var list = jsonDecode(bodyText);

    return list.map<ListSpec>((data) {
      return ListSpec.fromJson(data);
    }).toList();
  }

  static Future removeItem(String title) async {
    var svar =
        await http.delete(Uri.parse('$API_URL/todos/$title?key=$API_KEY'));
    var bodyText = svar.body;
    var list = jsonDecode(bodyText);
    return list.map<ListSpec>((data) {
      return ListSpec.fromJson(data);
    }).toList();
  }

  static Future<List<Listan>> getItem() async {
    var svar = await http.get(Uri.parse('$API_URL/todos?key=$API_KEY'));
    String bodyText = svar.body;
    var json = jsonDecode(bodyText);
    return json.map<ListSpec>((data) {
      return ListSpec.fromJson(data);
    }).toList();
  }
}
