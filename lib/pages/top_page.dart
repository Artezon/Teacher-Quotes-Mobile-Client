import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../api_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';

enum ContentType { faculty, teacher }

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Топ')),
      body: null,
    );
  }
}
