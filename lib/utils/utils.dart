import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static setUserId(int userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("userId", userId);
  }

  static getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("userId");
  }

  static setIsAuthenticated(bool isAuthenticated) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isAuthenticated", isAuthenticated);
  }

  static getIsAuthenticated(bool isAuthenticated) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isAuthenticated");
  }

  static displaySnackbar({required BuildContext context, required String message, Color? backgroundColor}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Utilities.getSnackBar(
        context: context,
        snackBar: SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 15)),
          duration: const Duration(milliseconds: 2500),
          backgroundColor: backgroundColor,
        ),
      );
    });
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static Future<bool?> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Item"),
            content: const Text("Are you sure you want to delete the item?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Utilities.closeActivity(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    Utilities.closeActivity(context);
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  static Future<File?> addImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      File? file = File(result.path);
      return file;
    } else {
      return null;
    }
  }

  static Future<File?> addFile(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx', 'doc', 'pptx']);

    if (result != null) {
      File? file = File(result.files.single.path ?? "");
      return file;
    } else {
      return null;
    }
  }

  static launchFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to open url : $url';
    }
  }
}
