import 'package:flutter/material.dart';

import 'package:printnotes/utils/handlers/open_url_link.dart';
import 'package:printnotes/constants/library_list.dart';

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
                      urlHandler(context, libraries[index].url);
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
                            .withValues(alpha: 0.5)),
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
