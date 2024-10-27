# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE)

**Inspired by Google Keep and Obsidian**

\*I will make <a href='https://github.com/quillpad/quillpad'>QuillPad</a> cry for not going cross-platform, but they got me beat on checkboxes, jk nice app

<img src="https://github.com/RoBoT095/printnotes/blob/main/images/AllThemes.png?raw=true" alt="all themes" />

## Features

- Supports Markdown... obviously
- Supports LaTeX used for math notation: <a href='https://quickref.me/latex'>cheatsheet</a>
- Stores notes locally on device
- Possible to create folders to better organize notes
- Has many colors to choose from by default
- Simple search to find any note by name, even the ones deeper in a folder
- Changeable layout and sort order
- Toolbar for easy markdown editing (borrowed from [simple_markdown_editor](https://github.com/zahniar88/simple_markdown_editor))
<!-- - Supports Windows, Mac, Linux, Android, and iOS -->

---

<details close>
<summary>Mobile screenshots</summary>

<p>
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneDrawer.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneSettings.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditor.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditing.png?raw=true" alt="all themes" width=200 />
</p>

</details>

<details close>
<summary>Desktop screenshots</summary>

<p>
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopHome.png?raw=true" alt="all themes" width=500 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopEditor.png?raw=true" alt="all themes" width=500 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopSettings.png?raw=true" alt="all themes" width=500 />
</p>
</details>

## Changelog

<details close>
<summary>Tap to show/hide the change history</summary>

### (Oct 27, 2024)

Syncthing for android is being discontinued - read [here](https://forum.syncthing.net/t/discontinuing-syncthing-android/23002?ref=news.itsfoss.com), which I personally use.

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

</details>

## Possible Future Features (not guaranteed)

- - [x] Custom themes with import capability
- - [ ] Advanced search with filters
- - [x] Tags
- - [ ] Upload and attach pictures
- - [ ] Share notes
- - [ ] Mobile Widgets 🤔?
- Sync options (possible to use SyncThing or Nextcloud app on the notes folder directly)
  - - [x] NextCloud (can manually upload, no file comparison or automatic sync option out yet)
  - ~~Dropbox~~
  - ~~Google Drive~~
  - - [ ] RSync
  - - [ ] FTP

## Supported Platforms

I will release apps when I feel like the app is more complete!

- [ ] Android `coming soon`
- [ ] iOS `coming soon`
- [ ] Windows `coming soon`
- [ ] MacOS `coming soon`
- [ ] Linux `coming soon`

---

## Compiling the app

<details close>
<summary>Tap to show/hide build instructions</summary>

Make sure you have a working flutter sdk setup. If not installed, go to [Install - Flutter](https://docs.flutter.dev/get-started/install) and select your platform.

Be sure to disable signing on build.gradle or change keystore to sign the app.

Before you start building, run these commands:

```
$ flutter channel stable
```

```
$ flutter upgrade
```

After that, building is as simple as running these commands:

```
$ flutter pub get
```

```
$ flutter run lib/main.dart
```

```
$ flutter build <target>
```

## Targets available for flutter:

- `aar`: Build a repository containing an AAR and a POM file.
- `apk`: Build an Android APK file from app.
- `appbundle`: Build an Android App Bundle file from app.
- `bundle`: Build the Flutter assets directory from app.
- `web`: Build a web application bundle. **(Won't work because app needs device storage access)**

### Device host specific

In other words, compiling can only be done on device you are compiling for (ex: `app.exe` requires windows)

- `linux`: Build a Linux desktop application.
- `windows`: Build a Windows desktop application.
- `macos`: Build a MacOS desktop application.
  - `ipa`: Build an iOS App Store Package from app.

</details>

### Known issues with running app as linux application on Linux Mint

<details close>
<summary>Tap to see issue details</summary>

**<u>Note: This doesn't seem to affect other types of distros, or when running android emulator</u>**

Running as linux application on flutter version _3.24.0-3.24.3_ causes any **TextFields** to <u>slows down</u> or <u>crash</u> the app (ex. editing note, creating note/folder, searching, etc), best workaround currently is to switch to version [3.22.3 following this link](https://docs.flutter.dev/release/upgrade#switching-to-a-specific-flutter-version) and changing all `onPopInvokedWithResult` to just `onPopInvoked` as it doesn't exist in this version, if you are still having issues, try running `flutter clean` then `flutter run lib/main.dart` again, let me know if you have any other issues or need a step-by-step guide.

</details>

## Donations

Feel free to support me and my work

[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/RoBoT_095/donate)
