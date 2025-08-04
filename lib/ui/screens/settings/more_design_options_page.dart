import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/utils/handlers/style_handler.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/centered_page_wrapper.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class MoreDesignOptionsPage extends StatefulWidget {
  const MoreDesignOptionsPage({super.key});

  @override
  State<MoreDesignOptionsPage> createState() => _MoreDesignOptionsPageState();
}

class _MoreDesignOptionsPageState extends State<MoreDesignOptionsPage> {
  bool _isLoading = false;
  List<DropdownMenuItem> _bgImgDropItemList = [];
  List<String> _bgImgPathList = [];

  @override
  void initState() {
    _loadImages();
    super.initState();
  }

  void _loadImages() async {
    setState(() => _isLoading = true);
    final List<DropdownMenuItem> saveStateList = [];
    final list = await StyleHandler.getBgImageList();
    for (String imgPath in list) {
      saveStateList.add(
          DropdownMenuItem(value: imgPath, child: Text(basename(imgPath))));
    }
    saveStateList.add(DropdownMenuItem(value: null, child: Text('No Image')));
    saveStateList.add(
        DropdownMenuItem(value: 'add new image', child: Text('+ Add Image')));
    setState(() {
      _bgImgDropItemList = saveStateList;
      _bgImgPathList = list;
      _isLoading = false;
    });
  }

  void delImgDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Images'),
        content: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            height: double.maxFinite,
            width: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _bgImgPathList.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_bgImgPathList[index])),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListTile(
                  title:
                      Text('${index + 1}. ${basename(_bgImgPathList[index])}'),
                  trailing: IconButton(
                      onPressed: () {
                        _deleteImage(context, _bgImgPathList[index]);
                        setState(() {
                          _bgImgDropItemList.removeWhere(
                              (e) => e.value == _bgImgPathList[index]);
                          _bgImgPathList
                              .removeWhere((e) => e == _bgImgPathList[index]);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _uploadImage(BuildContext context) async {
    final value = await StyleHandler.uploadBgImage();
    if (context.mounted) {
      if (value != null) {
        context.read<SettingsProvider>().setBgImagePath(value);
        _loadImages();
      }
    }
  }

  void _deleteImage(BuildContext context, String imgPath) async {
    await StyleHandler.deleteBgImage(imgPath);
    _bgImgDropItemList.removeWhere((e) => e.value == imgPath);
    _bgImgPathList.removeWhere((e) => e == imgPath);
    if (context.mounted) {
      if (context.read<SettingsProvider>().bgImagePath == imgPath) {
        context.read<SettingsProvider>().setBgImagePath(null);
      }
    }
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    final watchSettings = context.watch<SettingsProvider>();
    final readSettings = context.read<SettingsProvider>();

    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          centerTitle: true,
          title: const Text('More Design Options'),
        ),
      ),
      body: CenteredPageWrapper(
          child: ListTileTheme(
        iconColor: Theme.of(context).colorScheme.secondary,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  sectionTitle(
                    'Home Screen',
                    Theme.of(context).colorScheme.secondary,
                    padding: 10,
                  ),
                  Container(
                    // reflect the selected image
                    decoration: watchSettings.bgImagePath != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              repeat: StyleHandler.getBgImageRepeat(
                                  watchSettings.bgImageRepeat),
                              fit: StyleHandler.getBgImageFit(
                                  watchSettings.bgImageFit),
                              opacity: watchSettings.bgImageOpacity,
                              image:
                                  FileImage(File(watchSettings.bgImagePath!)),
                            ),
                          )
                        : null,
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Background Image'),
                      subtitle: Text('Replace background color with image'),
                      trailing:
                          // If empty, show icon, otherwise dropdown of images
                          _bgImgDropItemList.isNotEmpty &&
                                  _bgImgDropItemList[0].value != null &&
                                  _bgImgDropItemList[1].value != 'add new image'
                              ? DropdownButton(
                                  items: _bgImgDropItemList,
                                  value: watchSettings.bgImagePath,
                                  hint: Text('Select Image'),
                                  onChanged: (value) {
                                    if (value is String?) {
                                      if (value == 'add new image') {
                                        _uploadImage(context);
                                      } else {
                                        readSettings.setBgImagePath(value);
                                      }
                                    }
                                  },
                                )
                              : IconButton(
                                  onPressed: () => _uploadImage(context),
                                  icon: Icon(Icons.add)),
                    ),
                  ),
                  if (_bgImgDropItemList.isNotEmpty &&
                      _bgImgDropItemList[0].value != null &&
                      _bgImgDropItemList[1].value != 'add new image')
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete Image'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => delImgDialog(context),
                    ),
                  if (watchSettings.bgImagePath != null)
                    ListTile(
                      leading: Icon(Icons.opacity),
                      title: Text('Background Image Opacity'),
                      trailing: Text('${watchSettings.bgImageOpacity * 100}%'),
                      subtitle: Slider(
                        value: watchSettings.bgImageOpacity,
                        divisions: 10,
                        min: 0,
                        max: 1,
                        onChanged: (opacity) =>
                            readSettings.setBgImageOpacity(opacity),
                      ),
                    ),
                  if (watchSettings.bgImagePath != null)
                    ListTile(
                      leading: Icon(Icons.format_shapes),
                      title: Text('Background Image fit'),
                      trailing: DropdownButton(
                        value: watchSettings.bgImageFit,
                        items: [
                          DropdownMenuItem(
                            value: 'cover',
                            child: Text('Cover'),
                          ),
                          DropdownMenuItem(
                            value: 'contain',
                            child: Text('Contain'),
                          ),
                          DropdownMenuItem(
                            value: 'fill',
                            child: Text('Fill'),
                          ),
                          DropdownMenuItem(
                            value: 'scaleDown',
                            child: Text('Scale Down'),
                          ),
                          DropdownMenuItem(
                            value: 'fitHeight',
                            child: Text('Fit Height'),
                          ),
                          DropdownMenuItem(
                            value: 'fitWidth',
                            child: Text('Fit Width'),
                          ),
                          DropdownMenuItem(
                            value: 'none',
                            child: Text('None'),
                          ),
                        ],
                        onChanged: (fit) {
                          if (fit != null) readSettings.setBgImageFit(fit);
                        },
                      ),
                    ),
                  if (watchSettings.bgImagePath != null)
                    ListTile(
                      leading: Icon(Icons.loop),
                      title: Text('Background Image Repeat'),
                      trailing: DropdownButton(
                        value: watchSettings.bgImageRepeat,
                        items: [
                          DropdownMenuItem(
                            value: 'noRepeat',
                            child: Text('No Repeat'),
                          ),
                          DropdownMenuItem(
                            value: 'repeat',
                            child: Text('Repeat'),
                          ),
                          DropdownMenuItem(
                            value: 'repeatX',
                            child: Text('Repeat X-Axis'),
                          ),
                          DropdownMenuItem(
                            value: 'repeatY',
                            child: Text('Repeat Y-Axis'),
                          ),
                        ],
                        onChanged: (repeat) {
                          if (repeat != null) {
                            readSettings.setBgImageRepeat(repeat);
                          }
                        },
                      ),
                    ),
                  ListTile(
                    leading: Icon(Icons.opacity),
                    title: Text('Note Opacity'),
                    trailing: Text('${watchSettings.noteTileOpacity * 100}%'),
                    subtitle: Slider(
                      value: watchSettings.noteTileOpacity,
                      divisions: 10,
                      min: 0.0,
                      max: 1,
                      onChanged: (opacity) =>
                          readSettings.setNoteTileOpacity(opacity),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt_rounded),
                    title: const Text('Note Text Preview Amount'),
                    subtitle: Slider(
                      value: context
                          .watch<SettingsProvider>()
                          .previewLength
                          .toDouble(),
                      min: 0,
                      max: 200,
                      divisions: 10,
                      label: sliderLabels(
                          context.watch<SettingsProvider>().previewLength),
                      onChanged: (value) {
                        context
                            .read<SettingsProvider>()
                            .setPreviewLength(value.toInt());
                      },
                    ),
                  ),
                  const Divider(),
                  sectionTitle(
                    'Grid/List View Specific',
                    Theme.of(context).colorScheme.secondary,
                    padding: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.interests),
                    title: Text('Note Tile Shape'),
                    trailing: DropdownButton(
                      value: watchSettings.noteTileShape,
                      items: [
                        DropdownMenuItem(
                          value: 'round',
                          child: Text('Round'),
                        ),
                        DropdownMenuItem(
                          value: 'square',
                          child: Text('Square'),
                        ),
                      ],
                      onChanged: (shape) {
                        if (shape != null) readSettings.setNoteTileShape(shape);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.padding),
                    title: Text('Note Tile Text Padding'),
                    trailing: Text('${watchSettings.noteTilePadding} px'),
                    subtitle: Slider(
                      value: watchSettings.noteTilePadding,
                      divisions: 20,
                      min: 5,
                      max: 25,
                      onChanged: (padding) =>
                          readSettings.setNoteTilePadding(padding),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.straighten),
                    title: Text('Note Tile Spacing'),
                    trailing: Text('${watchSettings.noteTileSpacing} px'),
                    subtitle: Slider(
                      value: watchSettings.noteTileSpacing,
                      divisions: 20,
                      min: 0,
                      max: 20,
                      onChanged: (spacing) =>
                          readSettings.setNoteTileSpacing(spacing),
                    ),
                  ),
                  const Divider(),
                  sectionTitle(
                    'Note Editor',
                    Theme.of(context).colorScheme.secondary,
                    padding: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.padding_outlined),
                    title: Text('Note Editor Padding'),
                    trailing: Text('${watchSettings.noteEditorPadding} px'),
                    subtitle: Slider(
                      value: watchSettings.noteEditorPadding,
                      divisions: 20,
                      min: 0,
                      max: 20,
                      onChanged: (padding) =>
                          readSettings.setNoteEditorPadding(padding),
                    ),
                  ),
                  // const Divider(),
                  // ListTile(
                  //   title: Text(''),
                  // ),
                ],
              ),
      )),
    );
  }

  String sliderLabels(int value) {
    String valString = value.toString();
    if (value == 0) {
      return 'Title Only: $valString';
    }
    if (value == 100) {
      return 'Default: $valString';
    }
    return valString;
  }
}
