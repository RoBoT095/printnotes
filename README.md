# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE)

**Inspired by Google Keep and Obsidian**

> I will make <a href='https://github.com/quillpad/quillpad'>QuillPad</a> cry for not going cross-platform, but they got me beat on checkboxes, jk nice app

<img src="https://github.com/RoBoT095/printnotes/blob/main/images/AllThemes2-smaller.png?raw=true" alt="all themes" />

## Features

- Supports Markdown... obviously
- Supports LaTeX used for math notation: <a href='https://quickref.me/latex'>cheatsheet</a>
- Stores notes locally on device
- Possible to create folders to better organize notes
- Can view images and pdf files found in selected directory and in external folders
- Has many colors to choose from by default
- Changeable layout and sort order
- Toolbar for easy markdown editing (borrowed from [simple_markdown_editor](https://github.com/zahniar88/simple_markdown_editor))
- Create your own custom color schemes to better personalize it to your liking
<!-- - Supports Windows, Mac, Linux, Android, and iOS -->

---

## Images

<details close>
<summary>Mobile screenshots</summary>

<p>
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneGridView.png?raw=true" alt="phone grid view" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneListView.png?raw=true" alt="phone list view" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneTreeView.png?raw=true" alt="phone tree view" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditor.png?raw=true" alt="phone editor preview" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneEditing.png?raw=true" alt="phone editor edit" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneSettings.png?raw=true" alt="phone settings" width=200 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Phone/PhoneAdvancedSearch.png?raw=true" alt="phone tag search" width=200 />
</p>

</details>

<details close>
<summary>Desktop screenshots</summary>

<p>
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopGridView.png?raw=true" alt="desktop grid view" width=500 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopListView.png?raw=true" alt="desktop list view" width=500 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopTreeView.png?raw=true" alt="desktop tree view" width=500 />
  <img src="https://github.com/RoBoT095/printnotes/blob/main/images/Desktop/DesktopEditor.png?raw=true" alt="desktop editor" width=500 />
</p>
</details>

## Changelog - [here](https://github.com/RoBoT095/printnotes/blob/main/CHANGELOG.md)

<!-- ## Possible Future Features (not guaranteed)

- - [x] Custom themes with import capability
- - [x] Advanced search with filters
- - [x] Tags
- - [ ] Upload and attach pictures
- - [ ] Share files from app
- - [ ] Mobile Widgets 🤔?
  - One Way Sync Options (Bi-Directional Sync will come in the distant future)
    - - [ ] NextCloud
    - - [ ] RSync
    - - [ ] FTP
    - ~~Dropbox~~
    - ~~Google Drive~~ -->

## Supported Platforms

I will release apps when I feel like the app is more complete!

- [ ] Android
  - Can't get past GooglePlay review due to the use of All File Access permission
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

<a href="https://liberapay.com/RoBoT_095/donate" target="_blank"><img src="https://liberapay.com/assets/widgets/donate.svg" height=30 /></a>
<a href="https://ko-fi.com/robot095/donate" target="_blank"><img src="https://ko-fi.com/img/githubbutton_sm.svg" height=30 /></a>
<a href="https://buymeacoffee.com/robot_095" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="30"></a>
<a href="https://opencollective.com/webpack/donate" target="_blank"><img src="https://opencollective.com/webpack/donate/button@2x.png?color=blue" height=30 /></a>
