# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE)

**Inspired by Google Keep and Obsidian**

\*I will make <a href='https://github.com/quillpad/quillpad'>QuillPad</a> cry for not going cross-platform, but they got me beat on checkboxes, jk nice app

<img src="https://github.com/RoBoT095/printnotes/blob/main/images/AllThemes.png?raw=true" alt="all themes" />

## Features

- Supports Markdown... obviously
- Supports LaTeX used for math notation: <a href='https://quickref.me/latex'>cheatsheet</a>
- Stores notes locally on device
- Possible to create folders to store notes in
- Has many colors to choose from
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
<summary>Tap to show/hide the see changes history</summary>

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

   (need to figure out how to version app cuz I never done this before ┐(￣ヘ￣)┌ so version will remain till I get sync completed)

</details>

## Possible Future Features (not guaranteed)

- - [ ] Custom theme maker with import/export capability
- - [ ] Advanced search with filters
- - [ ] Tags
- - [ ] Upload and attach pictures
- - [ ] Share notes
- - [ ] Mobile Widgets 🤔?
- Sync options (possible to use SyncThing or Nextcloud app on the notes folder directly)
  - - [ ] NextCloud (can upload, no file comparison or automatic sync option out yet)
  - ~~Dropbox~~
  - ~~Google Drive~~
  - - [ ] RSync
  - - [ ] FTP

## Supported Platforms

I will release apps when I feel like the app is more complete! Also, ordered a mac mini which is coming soon so I can test on MacOS and iOS :D

- [ ] Android `coming soon`
- [ ] iOS `coming soon`
- [ ] Windows `coming soon`
- [ ] macOS `coming soon`
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
$ flutter run
```

```
$ flutter build platform-name
```

</details>

## Donations

Feel free to support me and my work

[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/RoBoT_095/donate)
