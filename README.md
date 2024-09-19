# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE.md)

**Inspired by Google Keep and Obsidian**

<img src="https://github.com/RoBoT095/printnotes/blob/main/images/AllThemes.png?raw=true" alt="all themes" />

## Features

- Supports Markdown... obviously
- Stores notes locally on device
- Possible to create folders to store notes in
- Has many colors to choose from
- Simple search to find any note by name, even the ones deeper in a folder
- Notes can be archived, soft deleted aka deleted after a set time, or completely wiped
- Changeable layout and sort order
- Toolbar for easy markdown editing (borrowed from [simple_markdown_editor](https://github.com/zahniar88/simple_markdown_editor))
<!-- - Supports Windows, Mac, Linux, Android, and iOS -->

---

<details open>
<summary>Tap to show/hide screenshots</summary>

<p>
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneDrawer.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneSettings.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditor.png?raw=true" alt="all themes" width=200 />
    <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditing.png?raw=true" alt="all themes" width=200 />
</p>
</details>

## Changelog

<details close>
<summary>Tap to show/hide the see changes history</summary>

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

## Future Features on the List

- - [ ] Custom theme maker with import/export capability
- - [ ] Advanced search with filters
- - [ ] Tags
- - [ ] Upload and attach pictures
- - [ ] Share notes
- Sync options (possible to use SyncThing on the notes folder)
  - - [ ] NextCloud (can upload, no file comparison or automatic sync option out yet)
  - - [ ] Dropbox
  - - [ ] Google Drive
  - - [ ] RSync
  - - [ ] FTP

## Supported Platforms

I will release apps when I feel like the app is more complete!

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
