import 'package:flutter/material.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class MoreDesignOptionsPage extends StatelessWidget {
  const MoreDesignOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          repeat: ImageRepeat
                              .noRepeat, // TODO: Reflect user settings
                          fit: BoxFit.cover, // TODO: Reflect user settings
                          opacity: 0.2, // TODO: Reflect user settings
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1750412143850-68d5003c6a36?q=80&w=736&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'))),
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Background Image'),
                    subtitle: Text('Replace background color with image'),
                    trailing:
                        // If empty, show icon, otherwise dropdown of images
                        true != true
                            ? DropdownButton(
                                items: [],
                                onChanged: (value) {},
                              )
                            : IconButton(
                                onPressed: () {}, icon: Icon(Icons.add)),
                  ),
                ),
                // TODO: IF IMAGE IS SELECTED
                ListTile(
                  leading: Icon(Icons.opacity),
                  title: Text('Background Image Opacity'),
                  trailing: Text('${20}%'), // TODO: insert slider value
                  subtitle: Slider(
                    value: 20, // TODO: add dynamic value
                    divisions: 10,
                    min: 0,
                    max: 100,
                    onChanged: (value) {},
                  ),
                ),
                // TODO: IF IMAGE IS SELECTED
                ListTile(
                  leading: Icon(Icons.format_shapes),
                  title: Text('Background Image fit'),
                  trailing: DropdownButton(
                    value: 'cover', // TODO: add dynamic value
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
                    onChanged: (value) {},
                  ),
                ),
                // TODO: SHOW ONLY IF IMAGE IS SELECTED
                ListTile(
                  leading: Icon(Icons.loop),
                  title: Text('Background Image Repeat'),
                  trailing: DropdownButton(
                    value: 'noRepeat', // TODO: add dynamic value
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
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.opacity),
                  title: Text('Note Opacity'),
                  trailing: Text('${100}%'), // TODO: insert slider value
                  subtitle: Slider(
                    value: 100, // TODO: add dynamic value
                    divisions: 10,
                    min: 0,
                    max: 100,
                    onChanged: (value) {},
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
                    value: 'round', // TODO: add dynamic value
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
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.padding),
                  title: Text('Note Tile Padding'),
                  trailing: Text('10'), // TODO: insert slider value
                  subtitle: Slider(
                    value: 10, // TODO: add dynamic value
                    min: 5,
                    max: 25,
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.straighten),
                  title: Text('Note Tile Spacing'),
                  trailing: Text('4'), // TODO: insert slider value
                  subtitle: Slider(
                    value: 4, // TODO: add dynamic value
                    min: 0,
                    max: 20,
                    onChanged: (value) {},
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
