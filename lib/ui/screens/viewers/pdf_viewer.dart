import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:printnotes/utils/open_explorer.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({super.key, required this.pdfUri});

  final Uri pdfUri;

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final PdfViewerController pdfController = PdfViewerController();
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  bool _isSearching = false;
  bool searchToggled = false;

  @override
  void dispose() {
    _searchResult.removeListener(_onSearchUpdated);
    _searchResult.clear();
    searchTextController.dispose();
    focusNode.dispose();
    pdfController.dispose();
    super.dispose();
  }

  // Listener to refresh screen when the search instance changes (jumps)
  void _onSearchUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  // Perform search and attach listener so arrows work
  void _performSearch(String query) {
    _searchResult.removeListener(_onSearchUpdated);

    if (query.isEmpty) {
      _searchResult.clear();
      if (mounted) setState(() => _isSearching = false);
      return;
    }

    if (mounted) {
      setState(() => _isSearching = true);
    }

    _searchResult = pdfController.searchText(query);

    _searchResult.addListener(_onSearchUpdated);

    if (mounted) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDragWrapper(
        bottom: searchToggled ? kToolbarHeight : 0,
        child: AppBar(
          centerTitle: true,
          title: SelectableText(
            path.basename(widget.pdfUri.toFilePath()),
            maxLines: 1,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggled = !searchToggled;

                    if (!searchToggled) {
                      searchTextController.clear();
                      _searchResult.removeListener(_onSearchUpdated);
                      _searchResult.clear();
                    }
                  });
                },
                color: searchToggled
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurface,
                icon: const Icon(Icons.search)),
            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (context) => <PopupMenuEntry>[
                if (!Platform
                    .isLinux) // Is currently files not supported by SharePlus
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.share),
                      title: Text('Share'),
                      onTap: () {
                        SharePlus.instance.share(ShareParams(
                            files: [XFile(widget.pdfUri.toFilePath())]));
                      },
                    ),
                  ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: const Text("Open Location"),
                    iconColor: mobileNullColor(context),
                    textColor: mobileNullColor(context),
                  ),
                  onTap: () async => await openExplorer(context, widget.pdfUri),
                ),
              ],
            ),
          ],
          bottom: searchToggled
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: searchBar())
              : null,
        ),
      ),
      body: SfPdfViewer.file(
        File(widget.pdfUri.toFilePath()),
        controller: pdfController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowHyperlinkDialog: true,
        onDocumentLoaded: (details) => setState(() {}),
        onPageChanged: (details) => setState(() {}),
        onZoomLevelChanged: (details) => setState(() {}),
      ),
      bottomNavigationBar: bottomControls(),
    );
  }

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      child: Column(
        children: [
          _isSearching
              ? const LinearProgressIndicator(minHeight: 4)
              : const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    TextField(
                      autofocus: true,
                      focusNode: focusNode,
                      controller: searchTextController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(right: 50),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        _performSearch(value);
                      },
                    ),
                    if (_searchResult.hasResult)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_searchResult.currentInstanceIndex} / ${_searchResult.totalInstanceCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: _searchResult.hasResult &&
                        _searchResult.currentInstanceIndex > 1
                    ? () {
                        _searchResult.previousInstance();
                      }
                    : null,
                icon: const Icon(Icons.arrow_upward),
                iconSize: 20,
              ),
              IconButton(
                onPressed: _searchResult.hasResult &&
                        _searchResult.currentInstanceIndex <
                            _searchResult.totalInstanceCount
                    ? () {
                        _searchResult.nextInstance();
                      }
                    : null,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
              ),
              IconButton(
                onPressed: searchTextController.text.isNotEmpty
                    ? () {
                        searchTextController.clear();
                        _searchResult.removeListener(
                          _onSearchUpdated,
                        );
                        _searchResult.clear();
                        focusNode.requestFocus();
                        setState(() {});
                      }
                    : null,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget bottomControls() {
    return BottomAppBar(
      height: 48,
      padding: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: 'Top Page',
            icon: const Icon(Icons.first_page),
            onPressed: pdfController.pageNumber > 1
                ? () {
                    pdfController.jumpToPage(1);
                  }
                : null,
          ),
          IconButton(
            tooltip: 'Zoom Out',
            icon: const Icon(Icons.zoom_out),
            onPressed: pdfController.zoomLevel > 1.0
                ? () {
                    final newZoom = (pdfController.zoomLevel - 0.5).clamp(
                      1.0,
                      5.0,
                    );
                    pdfController.zoomLevel = newZoom;
                    setState(() {});
                  }
                : null,
          ),
          IconButton(
            tooltip: 'Zoom In',
            icon: const Icon(Icons.zoom_in),
            onPressed: pdfController.zoomLevel < 5.0
                ? () {
                    final newZoom = (pdfController.zoomLevel + 0.5).clamp(
                      1.0,
                      5.0,
                    );
                    pdfController.zoomLevel = newZoom;
                    setState(() {});
                  }
                : null,
          ),
          IconButton(
            tooltip: 'Last Page',
            icon: const Icon(Icons.last_page),
            onPressed: pdfController.pageNumber < pdfController.pageCount
                ? () {
                    pdfController.jumpToPage(pdfController.pageCount);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
