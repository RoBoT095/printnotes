import 'package:flutter/material.dart';

void showRadioListDialog(
  BuildContext context, {
  Widget? tileTitle,
  required String selectedItem,
  required List<String> items,
  required ValueChanged<String> onUpdated,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: tileTitle,
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return PopupMenuItem(
                child: RadioListTile(
                  title: Text(items[index],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  value: items[index],
                  groupValue: selectedItem,
                  onChanged: (value) {
                    selectedItem = value!;
                    onUpdated(value);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
