import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/storage_system.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
    required this.searchQuery,
  });

  final String searchQuery;

  Widget? _buildSubtitle(BuildContext context, File item) {
    final relativePath = path.relative(item.path,
        from: context.watch<SettingsProvider>().mainDir);
    String text = File(item.path).readAsStringSync().replaceAll('\n', ' ');
    int maxChar = 40;

    String textLC = text.toLowerCase();
    String searchQueryLC = searchQuery.toLowerCase();

    // if search result empty, return empty text subtitle
    if (searchQueryLC.isEmpty || !textLC.contains(searchQueryLC)) {
      return Text('/$relativePath');
    }

    final int startIndex = textLC.indexOf(searchQueryLC);
    // if search query not found, display first few characters based on maxChar
    // of file text followed by ellipsis
    if (startIndex == -1) {
      return Text(
          '${text.substring(0, text.length < maxChar ? text.length : maxChar).trim()}...');
    }

    final int endIndex = startIndex + searchQuery.length;
    final int previewStart = startIndex > 25 ? startIndex - 25 : 0;
    final int previewEnd =
        text.length > endIndex + 25 ? endIndex + 25 : text.length;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          // if search query not at start of text, add ellipsis in the front
          if (previewStart > 0) const TextSpan(text: '...'),
          TextSpan(text: text.substring(previewStart, startIndex)),
          // Bold the text you have entered
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // display the rest of the result with ellipsis if too long
          TextSpan(text: text.substring(endIndex, previewEnd)),
          if (previewEnd < text.length) const TextSpan(text: '...'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foundItemsList = StorageSystem.searchItems(
        searchQuery, context.watch<SettingsProvider>().mainDir);

    return FutureBuilder(
      future: foundItemsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final item = snapshot.data![index];

            return ListTile(
              leading: Icon(
                Icons.insert_drive_file,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(path.basename(item.path)),
              subtitle: _buildSubtitle(context, File(item.path)),
              onTap: () {
                // Should never be a folder but it is just a backup check unless I messed something up
                if (item is File) {
                  context
                      .read<NavigationProvider>()
                      .routeItemToPage(context, item.uri);
                }
              },
            );
          },
        );
      },
    );
  }
}
