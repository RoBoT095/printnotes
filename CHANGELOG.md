# Changelog

## (Nov 11, 2024)

Added info pop up for notes like amount of characters, words, file size, file mod date, and file path/location. Fixed issue with expandedColor not set on toolbar white would default to white, so in dark mode made it impossible to see icons in most cases.

## (Nov 9, 2024)

Made table of contents into a end drawer (drawer that opens from right side instead) and made content center on large screens for note editor, image viewer, settings, about, and custom colors screen, debating if other screens also need it.

Removed all files related to syncing, will keep them on `dev` branch instead.

## (Nov 5, 2024)

Search can now find tags if you click on filter icon to toggle advanced search and type "tags:" and then enter the name of the tag you want to find. Changed how tags look like as they can me a bit too light or dark depending on theme, still not the best fix, but is better. Changed available images to reflect the changes

## (Nov 4, 2024)

Added advanced search for searching the contents of notes. Moved "sort by" button into the 3 dot "more" popup menu, as well as made "change layout" into a popup menu as well

## (Nov 3, 2024)

Moved Grid/List views into a separate file, fixed up some functions in storage_system.dart to remove a few duplicate code, and changed some text like "Note" to "File" as app now supports images as well. Still need to fix archiving and soft deletion for images.

## (Nov 2, 2024)

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
