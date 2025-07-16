import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/utils/handlers/style_handler.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class MoreDesignOptionsPage extends StatefulWidget {
  const MoreDesignOptionsPage({super.key});

  @override
  State<MoreDesignOptionsPage> createState() => _MoreDesignOptionsPageState();
}

class _MoreDesignOptionsPageState extends State<MoreDesignOptionsPage> {
  List<DropdownMenuItem> _bgImgList = [];

  @override
  void initState() {
    _loadImages();
    super.initState();
  }

  void _loadImages() async {
    final List<DropdownMenuItem> saveStateList = [];
    final list = await StyleHandler.getBgImageList();
    for (String imgPath in list) {
      saveStateList.add(
          DropdownMenuItem(value: imgPath, child: Text(basename(imgPath))));
    }
    saveStateList.add(DropdownMenuItem(value: null, child: Text('No Image')));
    saveStateList.add(
        DropdownMenuItem(value: 'add new image', child: Text('+ Add Image')));
    setState(() => _bgImgList = saveStateList);
  }

  void _uploadImage(BuildContext context) async {
    final res = await StyleHandler.uploadBgImage();
    if (context.mounted) {
      if (res == true) {
        _loadImages(); // refresh
      }
    }
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
      body: DefaultTabController(
          length: 3,
          child: ListTileTheme(
            iconColor: Theme.of(context).colorScheme.secondary,
            child: ListView(
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
                            image: FileImage(File(watchSettings.bgImagePath!)),
                          ),
                        )
                      : null,
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Background Image'),
                    subtitle: Text('Replace background color with image'),
                    trailing:
                        // If empty, show icon, otherwise dropdown of images
                        _bgImgList.isNotEmpty
                            ? DropdownButton(
                                items: _bgImgList,
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
                  title: Text('Note Tile Padding'),
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
                // const Divider(),
                // ListTile(
                //   title: Text(''),
                // ),
              ],
            ),
          )),
    );
  }
}
