# Changelog + Dev Log

### (July 16 - August 2, 2025)

Been working on new styling options and forgot to write changelog

- Removed Table of Contents in favor of scroll position remembered between edit and preview mode (might rework it back in later)
- In settings, removed layout section and moved to styling and the new "More Options" page
- In More Design Options page, added:
  - Home Screen settings:
    - Background image
      - Bg Image opacity, fit, and repeat
    - Note Tile Opacity
    - Note Text Preview Amount
  - Grid/List View Specific settings:
    - Note Tile Shape (round or square border)
    - Note Tile Text Padding (spacing between border and text)
    - Note Tile Spacing (space between each tile)
  - Note Editor settings:
    - Note Editor Padding (space between edge and text)

### July (12 & 25, 2025)

Fixed certain things not reloading page due to the optimization changes

### (July 6, 2025)

- Merged url handlers
- Fixed pdf search bar
- Optimized general searching
- Changed StorageSystem.listFolderContents into a Future which in theory should improve performance
- Changed StorageSystem.getFilePreview into a Future
- Migrates withOpacity to withValues()
- App version bump

### (July 4-5, 2025)

- Moved [markdown_widget](https://github.com/asjqkkkk/markdown_widget) library in house to have better control over it for future updates
- Added ability to link to files with WikiLinks and regular links
- Forgot to mention that I bumped flutter version from `3.32.2` to `3.32.5` due to some bugs with that version
- Added option to hide title bar on linux and windows
- On desktop, title bars (aka AppBar) in the app can now be used to grab the window around

### (June 11, 2025)

- Improved local image relative path logic further

### (June 10, 2025)

- Changed logic for referencing local images to allow relative path
- Added internet usage info page to IntroScreen to clear confusion regarding internet access

### (June 7, 2025)

- Upgraded project from flutter version `3.29.2` to `3.32.2`
  - As well as upgraded pub dependencies/libraries
- Added ability to parse CSV files into markdown tables for previewing
- Fixed error when having unsupported file types in app (broke it when adding frontmatter support)

### (June 3, 2025)

- Redesigned drawer into a rail of icons for larger screens

### (June 1, 2025)

- Fixed exiting without editing note updates last modified date
- Added sorting option called folder priority, or show folders above or below files or none aka don't separate
- Added sort order to settings screen as well

### (May 17, 2025)

- Added markdown table maker to toolbar

### (May 16, 2025)

- Removed the added empty lines above and below horizontal rule from the toolbar shortcut
- Fixed image and pdf not rendering when frontmatter enabled

### (April 12-13, 2025)

- Added Frontmatter support for tags: (**Note:** colors can only be hex values in quotation marks ex. '#cbff90')

  - title -> Displays set title rather then file name
  - description -> Overrides preview of file content with set description
  - color -> Changes the color of the text
  - background -> Changes the color of the background

- Added button in drawer to github wiki

### (April 11, 2025)

- Added ability to display local images inside markdown notes
- Made file titles selectable on long press

### (April 9, 2025)

- Fixed Markdown syntax for tags, highlights, and underlines reverting to default font size when in a list

### (April 6-8, 2025)

- Added way to open pdf files on android from file manager (aka Receiving Media Intent)
- Updated to latest flutter version `3.29.2`
- Switched to using double space for indentation as tab (`\t`) breaks indents for lines underneath
- Added option to make dark mode background pure black for builtin themes
- Added option to switch between different codeblock themes

### (Mar 7, 2025)

- Added underline markdown syntax (ex. `__text__`) as html syntax wasn't working (my bad for not testing)
- Note editor now check for external changes to file
- Notes are no longer saved on immediate change but every 3 seconds instead

### (Feb 22, 2025)

- Upgraded to flutter version `3.29.0`.
- Fixed archive and trash paths not updating when changing notes location.
- Added popup for delete config button in settings
- Fixed minor error with deleteJsonConfigFile not loading new config in time

### (Feb 16, 2025)

- Fixed drawer "All Notes" button not redirecting user to homepage/main folder
- Notes preview will reflect changes when you exit note editor
- Fixed permanent delete was trashing instead of deleting
- Changed when notes are created, if extension is added by user, will not add `.md` on top of it
- Added Refresh on pull up for Grid/List view for mobile
- Expanded access to allow all file extension types, will instead show error message if reading file is not possible
- Renamed a lot of things from "note" to "file"

### (Feb 14, 2025)

- Moved toolbarConfig from `SharedPreference` into the `main_config.json` file
- Made small modifications to custom color list tiles
- Added option to delete and generate new config file from settings screen

### (Feb 9-11, 2025)

- Added Editor Configuration page to the 'more' button in note editor
  - Modify font size of markdown text
  - Rearrange toolbar items
  - Show/hide toolbar items

### (Feb 8, 2025)

- Fixed files not displaying when the main selected folder is a hidden folder (aka starts with '.')
- Route history resets when changing notes folder now
- Fixed navigation history when you enter into trash or archive while not on main home screen

### (Feb 7, 2025)

- Moved `ItemNavigation` into `NavigationProvider` and unified route history for notes, trash, and archive screens as well as expanded to include files as well
- Fixed search throwing user to main folder even when in a different folder and not updating route history
- Fixed file/folder creation not happening in current folder and not reloading page
- Added check on launch if app hasn't lost `externalStoragePermissions` on android if not new user
- Disabled drawer when searching
- Changed link in about screen from liberapay.com to buymeacoffee.com

### (Feb 5, 2025)

~~**v0.9.13**~~

jumped the gun

**Note**: This only applies to grid and list views as tree view requires a different approach

- Added option to select many notes and perform bulk actions like
  - moving
  - deleting

**Changes:**

- Added `SelectingProvider` to deal with selected items more easily.
- Fixed speed dial as accidentally put `.watch()` instead of `.read()` on a onTap.
- Fixed tree view using hardcoded backslash instead of platform path separator.
- Made dialog for selecting where to move items say main folder path location as I found it confusing being unsure where I was at first glance.
- ~~Disabled sort options for tree view as they didn't work either way.~~ Fixed (02/06/2025)
- Changed wording in item delete handler for soft delete from 'delete' to 'trash' to not confuse users.

### (Feb 3, 2025)

Done something I should have done in the very beginning, using Provider for settings state management, changes should be imperceptible, but it will help keep code clean and make my life simpler with adding feature to perform bulk actions by selecting.

Need to completely remove `SettingsLoader` once I move out `loadItems()`, want to save work while it seems to all still be working normally.

### (Feb 1, 2025)

**~Work in Progress~**

Working on adding a item selection feature to perform bulk actions on notes like moving or deleting all selected items.

Will be part of 0.9.13, also version 0.9.12 doesn't have a release outside of iOS due to needing to fix permissions issue and how you can't release app with same version number even if build number is different on apple app store.

### (Jan 24-27, 2025)

Started working on releasing app to the Apple App Store but due to insufficient testing outside of iOS emulator, ended up learning more about how permissions are handled for iOS. To make the app work for ios, I hid the folder selection buttons and instead made the Apps documents directory visible in the Files app.

### (Jan 2-3, 2025)

- Added PDF Viewer to the app (I didn't have one on my phones, so I decided, why not add to my notes app)
- Added button home screen floating action button to open external images and PDF files from storage

Tried publishing app to Google Play Store, got passed closed testing, but when trying to release to production I got rejected multiple times for using MANAGE_EXTERNAL_STORAGE permission on android, they didn't like any of my reasons. I might need to figure out how to use ACTION_OPEN_DOCUMENT_TREE or something like it without breaking or rewriting the entire app. Couldn't find a good library that wasn't outdated or was too complex, so I might actually need to learn some Kotlin for this.

### (Dec 27, 2024)

Fixed search and removed hidden folders from results

### (Nov 30, 2024)

Made Snackbars prettier

### (Nov 25, 2024)

Fixed minor bugs and visual discrepancies, config file for custom themes is now looks readable with indentation instead of all being on one line.

### (Nov 11, 2024)

Added info pop up for notes like amount of characters, words, the file size, file mod date, and file path/location. Fixed issue with `expandableBackground` not set on toolbar which would default to white, so in dark mode made it impossible to see icons in most cases.

### (Nov 9, 2024)

Made table of contents into a end drawer (drawer that opens from right side instead) and made content center on large screens for note editor, image viewer, settings, about, and custom colors screen, debating if other screens also need it.

Removed all files related to syncing, will keep them on `dev` branch instead.

### (Nov 5, 2024)

Search can now find tags if you click on filter icon to toggle advanced search and type "tags:" and then enter the name of the tag you want to find. Changed how tags look like as they can me a bit too light or dark depending on theme, still not the best fix, but is better. Changed available images to reflect the changes

### (Nov 4, 2024)

Added advanced search for searching the contents of notes. Moved "sort by" button into the 3 dot "more" popup menu, as well as made "change layout" into a popup menu as well

### (Nov 3, 2024)

Moved Grid/List views into a separate file, fixed up some functions in storage_system.dart to remove a few duplicate code, and changed some text like "Note" to "File" as app now supports images as well. Still need to fix archiving and soft deletion for images.

### (Nov 2, 2024)

Added way to preview images from home screen and from a basic image viewer, this is in preparation to allow linking images in storage from inside notes.

Added third layout view "tree view", option from home screen just cycles through them, while in settings you specifically choose which one you want.

### (Oct 31, 2024)

**Happy Halloween**, not so happy day, sync enthusiasts, I am hiding the Sync option on the drawer and will be working on 1 way (upload only) sync in the mean time. I didn't realize how hard 2 way (bi-directional) syncing is, but I have been doing research and I have decided to still add it, it will just be a package I will try to make myself to later add to the app.

To explain why bi-directional sync is hard is that it would require creating a database that will log all changes of files and folders like creating, renaming, deleting, moving. A database is needed to prevent deleted files from infinity being added back to server by other devices, also, there is no good way to give files unique identifiers without adding something like '\_UniqueIdOfFile.md' to every file and removing it when displaying it on app to prevent the act of renaming a note creating duplicates on server or other connected devices.

### (Oct 27, 2024)

Syncthing for android is being discontinued - read [here](https://forum.syncthing.net/t/discontinuing-syncthing-android/23002?ref=news.itsfoss.com), which is what I personally use.

I am starting a 'dev' branch while I work a bit more on syncing (been putting it off cuz it drains all my motivation), currently trying to implement FTP as there is a package for it, so I hope it will be easier then messing with Nextcloud webdav. I will probably need to add file encryption when syncing, but that is a thought for a later date.

### (Oct 22, 2024)

Removed manual saving of notes, decided it wasn't worth it as these are simple notes meaning saving on change is fine, this means that the shortcut ctrl+s on desktop is also removed. Changed drawer icon to logo as well. If people want it, I can make a toggle is settings to enable and disable auto saving, returning the keyboard shortcuts and save buttons.

### (Oct 20-21, 2024)

Made save button on mobile into FAB at the bottom of the screen (hides behind keyboard as well) as it is harder to reach the save button on large phones, still in the same position on desktop. Desktop got a button to hide side ToC panel, open by default. Also, some other minor changes.

### (Oct 16, 2024)

Added a slider in settings to adjust how many characters are show for notes preview with option to do zero which will only display the title. Also, made the reload button on the scaffold of the note_display screen give user feedback by actually appearing to reload.

### (Oct 08-14, 2024)

Adding custom themes page that allows user to import a json string of a theme you get from [printnotes_theme_maker](https://github.com/RoBoT095/printnotes_theme_maker) (will be a website to make your own themes, its to avoid bloating app, plus easier to use on pc), and add a name to it to be saved into a list in a hidden json file called `.printnotes_config.json`.

All themes will be displayed on that screen split into light and dark, so user could pick one of each to be used when switching between brightness modes. If a selected color theme gets deleted, app uses the default for that brightness mode.

### (Oct 04, 2024)

1. Added custom ==highlighting== text syntax as well as #Tags, search by tag not implemented yet

### (Sept 28, 2024)

1. Made text on home screen a little bit smaller and added last modified ascending and descending to sort list
2. If a file that is not a markdown or txt file is attempted to be opened, message will pop up saying not supported
3. Removed future builder for note preview as it cause stuttering effect when scrolling up as items got unloaded and loaded, note preview is now readAsStringSync
4. Moved user preferences all into a single file, including: layout, theme/color, and sort order (now latex support too)
5. Added option in settings to toggle latex support for those that need it.

### (Sept 26, 2024)

1. Moved android 'allow external storage access' popup check to when selecting folder instead of when listing folder contents
2. You can now change file name from editor screen
3. Creating new note immediately opens the note
4. Added Table of Content for headers, on small display windows its a floating action button in the bottom right corner, on large displays its a side menu on the right if the note contains '# ' anywhere

### (Sept 24, 2024)

1. Removed soft delete and bin expiration time and made permanent delete default option
2. Made some styling changes to drawer
3. Moved folder navigation from SettingsLoader to ItemNavHandler, this was meant to always happen, I just like quick and dirty implementations
4. Replaced flutter_markdown with markdown_widget for better experience
   1. Code blocks are now colored if you specify language by adding it after the first three backticks, example ` ```Dart `
   2. App now supports LaTeX math notations
   3. Desktop version support saving using ctrl-s and switching editor preview/edit modes with ctrl-shift-v
5. On home page where all notes are displayed, the markdown images and links are now absorbed to only open note
6. Changed Snackbar a custom one that has a floating behavior instead of fixed
7. Changed out the screenshot to better reflect new look

### (Sept 22, 2024)

Added undo/redo buttons to text editor and on notes display screen made folder icon a little bit smaller with name maxlines extended from 1 to 2.

### (Sept 19, 2024)

Added app icons to different devices but I still need to check if they all work. Fixed the search and sort order buttons not updating screen when pressed, which happened when I was restructuring everything and forgot to check them.

### (Aug 22, 2024)

1. Added popup when you try to close app with back button.
2. Added Sync screen in drawer.
3. Added Secure Storage library for sync service credentials (meaning more dependencies required to install 😓).
4. Added a way to upload files and folders to your Nextcloud (actual auto syncing, will add in the future, hopefully soon).
5. Shows the last time you uploaded notes.
6. <u>TODO</u>: Made option to switch WiFi only or WiFi+Cellular upload condition but commented
   it out as I will add it when I figure out notes comparing and merging with sync service.

   (need to figure out how to version app cuz I never done this before ┐(￣ヘ￣)┌)
