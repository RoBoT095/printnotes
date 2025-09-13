import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/utils/open_explorer.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/dialogs/basic_popup.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({super.key, required this.pdfFile});

  final File pdfFile;

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final PdfViewerController pdfController = PdfViewerController();
  late final textSearcher = PdfTextSearcher(pdfController)
    ..addListener(_update);
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool linkHighlight = false;
  bool searchToggled = false;

  int currentZoom = 0;

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    textSearcher.removeListener(_update);
    textSearcher.dispose();
    searchTextController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> openLinkHandler(PdfLink link) async {
    if (link.url != null) {
      final response = await showBasicPopup(context, 'Open Link?',
          'Are you sure you want to open:\n${link.url}?');
      if (response) launchUrl(link.url!);
    } else if (link.dest != null) {
      pdfController.goToDest(link.dest);
    }
  }

  Widget pdfSpeedDial({bool? isOpen}) => SpeedDial(
        isOpenOnStart: isOpen ?? false,
        icon: Icons.add,
        activeIcon: Icons.close,
        tooltip: 'PDF Controls',
        closeManually: true,
        renderOverlay: false,
        overlayOpacity: 0,
        switchLabelPosition: true,
        children: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.zoom_out),
            onTap: () async {
              await pdfController.zoomDown();
              setState(() => currentZoom = pdfController.currentZoom.toInt());
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.zoom_in),
            onTap: () async {
              await pdfController.zoomUp();
              setState(() => currentZoom = pdfController.currentZoom.toInt());
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.last_page),
            onTap: () =>
                pdfController.goToPage(pageNumber: pdfController.pageCount),
          ),
          SpeedDialChild(
            child: const Icon(Icons.first_page),
            onTap: () => pdfController.goToPage(pageNumber: 1),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDragWrapper(
        bottom: searchToggled ? kToolbarHeight : 0,
        child: AppBar(
          centerTitle: true,
          title: SelectableText(
            widget.pdfFile.path.split('/').last,
            maxLines: 1,
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() => linkHighlight = !linkHighlight);
              },
              color: linkHighlight
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface,
              icon: const Icon(Icons.link),
            ),
            IconButton(
                onPressed: () {
                  setState(() => searchToggled = !searchToggled);
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
                        SharePlus.instance.share(
                            ShareParams(files: [XFile(widget.pdfFile.path)]));
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
                  onTap: () async =>
                      await openExplorer(context, widget.pdfFile.parent.path),
                ),
              ],
            ),
          ],
          bottom: searchToggled
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface))),
                      child: Column(
                        children: [
                          textSearcher.isSearching
                              ? LinearProgressIndicator(
                                  value: textSearcher.searchProgress,
                                  minHeight: 4,
                                )
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
                                        contentPadding:
                                            EdgeInsets.only(right: 50),
                                      ),
                                      textInputAction: TextInputAction.search,
                                      onChanged: (value) {
                                        textSearcher.startTextSearch(
                                          searchTextController.text,
                                          searchImmediately: true,
                                        );
                                      },
                                      onSubmitted: (value) {},
                                    ),
                                    if (textSearcher.hasMatches)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${textSearcher.currentIndex! + 1} / ${textSearcher.matches.length}',
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
                                onPressed: (textSearcher.currentIndex ?? 0) > 0
                                    ? () async {
                                        await textSearcher.goToPrevMatch();
                                        _update();
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_upward),
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: (textSearcher.currentIndex ?? 0) <
                                        textSearcher.matches.length
                                    ? () async {
                                        await textSearcher.goToNextMatch();
                                        _update();
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: searchTextController.text.isNotEmpty
                                    ? () {
                                        searchTextController.text = '';
                                        textSearcher.resetTextSearch();
                                        focusNode.requestFocus();
                                      }
                                    : null,
                                icon: const Icon(Icons.close),
                                iconSize: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      )))
              : null,
        ),
      ),
      body: PdfViewer.file(
        widget.pdfFile.path,
        controller: pdfController,
        params: PdfViewerParams(
          // Search
          pagePaintCallbacks: [textSearcher.pageTextMatchPaintCallback],
          // Clickable Links
          linkHandlerParams: linkHighlight
              ? PdfLinkHandlerParams(
                  onLinkTap: (link) => openLinkHandler(link),
                )
              : null,
          viewerOverlayBuilder: (context, size, handleLinkTap) => [
            // Double Taps for zoom
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: () {
                pdfController.zoomUp(loop: true);
              },
              onTapUp: (details) {
                handleLinkTap(details.localPosition);
              },
              child: IgnorePointer(
                child: SizedBox(width: size.width, height: size.height),
              ),
            ),
            // Side thumb with page number
            PdfViewerScrollThumb(
              controller: pdfController,
              orientation: ScrollbarOrientation.left,
              thumbSize: const Size(40, 25),
              thumbBuilder: (context, thumbSize, pageNumber, controller) =>
                  Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                // Show page number on the thumb
                child: Center(
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ),
            PdfViewerScrollThumb(
              controller: pdfController,
              orientation: ScrollbarOrientation.bottom,
              thumbSize: const Size(80, 25),
              thumbBuilder: (context, thumbSize, pageNumber, controller) =>
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimary),
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(
                        Icons.linear_scale,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
            ),
          ],
        ),
      ),
      floatingActionButton:
          pdfSpeedDial(isOpen: MediaQuery.sizeOf(context).width >= 800),
    );
  }
}
