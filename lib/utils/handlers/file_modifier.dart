import 'dart:io';

import 'package:flutter/material.dart';

// Code to implement androids SAF to not need 'MANAGE_EXTERNAL_STORAGE'
// permission without breaking other platforms
class FileModifier {
  final Uri uri;
  final bool isAndroid;

  FileModifier(this.uri) : isAndroid = Platform.isAndroid;

  Future<bool> create({bool isDir = false}) async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }

  Future<bool> exists() async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }

  Future<bool> delete() async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }

  Future<bool> rename(String newName) async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }

  Future<bool> moveTo({
    bool isDir = false,
    required Uri newParentUri,
  }) async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }

  Future<bool> stats({bool isDir = false}) async {
    try {
      //
    } catch (e) {
      debugPrint('error $e');
    }
    return true;
  }
}
