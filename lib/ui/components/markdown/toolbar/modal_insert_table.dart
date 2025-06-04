import 'package:flutter/material.dart';
import 'package:printnotes/ui/components/markdown/toolbar/toolbar.dart';

class ModalInsertTable extends StatefulWidget {
  const ModalInsertTable({
    super.key,
    required this.toolbar,
    required this.selection,
  });

  final Toolbar toolbar;
  final TextSelection selection;

  @override
  State<ModalInsertTable> createState() => _ModalInsertTableState();
}

class _ModalInsertTableState extends State<ModalInsertTable> {
  final _formKey = GlobalKey<FormState>();
  int _tableColumns = 0;
  int _tableRows = 0;

  @override
  Widget build(BuildContext context) {
    Widget formTextField(bool isColumn) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 15),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          autocorrect: false,
          autofocus: true,
          cursorRadius: const Radius.circular(20),
          decoration: InputDecoration.collapsed(
              hintText: "Number of ${isColumn ? 'Columns' : 'Rows'}."),
          style: const TextStyle(fontSize: 16),
          enableInteractiveSelection: true,
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter a number";

            final intVal = int.tryParse(value);
            if (intVal == null) return "Please enter a valid number";

            setState(
                () => isColumn ? _tableColumns = intVal : _tableRows = intVal);
            return null;
          },
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Insert Table",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            formTextField(true), // Column
            formTextField(false), // Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        StringBuffer markdownTable = StringBuffer();
                        // Create the header row
                        for (int i = 0; i < _tableColumns; i++) {
                          markdownTable.write('|   '); // Start for each header
                        }
                        markdownTable.writeln('|'); // End the header row

                        // Create the separator row
                        for (int i = 0; i < _tableColumns; i++) {
                          markdownTable
                              .write('|---'); // Separator for each column
                        }
                        markdownTable.writeln('|'); // End the separator row

                        // Create the data rows
                        for (int r = 0; r < _tableRows - 1; r++) {
                          for (int c = 0; c < _tableColumns; c++) {
                            markdownTable.write('|   '); // Start for each row
                          }
                          markdownTable.writeln('|'); // End the row
                        }
                        widget.toolbar.action(
                          markdownTable.toString(),
                          "",
                          textSelection: widget.selection,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Insert"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
