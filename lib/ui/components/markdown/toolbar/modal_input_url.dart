import 'package:flutter/material.dart';
import 'package:printnotes/ui/components/markdown/toolbar/toolbar.dart';

class ModalInputUrl extends StatelessWidget {
  const ModalInputUrl({
    super.key,
    required this.toolbar,
    required this.leftText,
    required this.selection,
  });

  final Toolbar toolbar;
  final String leftText;
  final TextSelection selection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please provide a URL here.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 15),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              autocorrect: false,
              autofocus: true,
              cursorRadius: const Radius.circular(20),
              decoration: const InputDecoration.collapsed(
                hintText: "Input your url.",
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
              enableInteractiveSelection: true,
              onSubmitted: (String value) {
                Navigator.pop(context);

                /// check if the user entered an empty input
                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "Please input url",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red.withOpacity(0.8),
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                } else {
                  if (!value.contains(RegExp(r'https?:\/\/(www.)?([^\s]+)'))) {
                    value = "http://$value";
                  }
                  toolbar.action(
                    "$leftText$value)",
                    "",
                    textSelection: selection,
                  );
                }
              },
            ),
          ),
          const Text(
            "example: https://example.com",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
