import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/ui/components/dialogs/basic_popup.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

Future<void> urlHandler(BuildContext context, String url,
    {bool copyToClipboard = false}) async {
  if (copyToClipboard) {
    await Clipboard.setData(ClipboardData(text: url)).then((_) {
      if (context.mounted) {
        customSnackBar('Copied to clipboard!', type: 'success').show(context);
      }
    });
  }

  Uri uri = Uri.parse(url);
  if (context.mounted) {
    final response = await showBasicPopup(
        context, 'Open Link?', 'Are you sure you want to open:\n$url?');
    if (response) {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
