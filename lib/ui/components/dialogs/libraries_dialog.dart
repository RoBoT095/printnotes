import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/constants/library_list.dart';

launchURL(String urlString) async {
  Uri url = Uri.parse(urlString);
  try {
    await launchUrl(url);
  } catch (e) {
    throw 'Could not launch $url with error $e';
  }
}

void showLibrariesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Libraries'),
        icon: const Icon(
          Icons.handshake,
          size: 40,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: libraries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      launchURL(libraries[index].url);
                    },
                    child: Text(
                        '${libraries[index].name} by ${libraries[index].publisher}'),
                  ),
                  subtitle: Text(
                    libraries[index].license,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
                  ),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Close',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
