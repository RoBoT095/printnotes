# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE)
[![IzzyOnDroid](https://img.shields.io/endpoint?url=https://apt.izzysoft.de/fdroid/api/v1/shield/com.printnotes.printnotes)](https://apt.izzysoft.de/fdroid/index/apk/com.printnotes.printnotes)
[![App Store](https://img.shields.io/badge/App_Store-0D96F6?logo=app-store&logoColor=white)](https://apps.apple.com/us/app/print-notes/id6740996365)

**Inspired by Google Keep and Obsidian**

> I will make <a href='https://github.com/quillpad/quillpad'>QuillPad</a> cry for not going cross-platform, but they got me beat on checkboxes, jk nice app

<img src="https://github.com/RoBoT095/printnotes/blob/main/images/AllThemes2-smaller.png?raw=true" alt="all themes" />

## Features

- Supports extended Markdown syntax
- Supports LaTeX used for math notation: <a target='_blank' href='https://quickref.me/latex'>cheatsheet</a>
- Supports Frontmatter for metadata and styling like title, description, color, and background
- All notes/files are stored locally on device
- Draw ideas with a sketchpad saved as `.bson` files
- Follows system folder structure to better organize notes
- Can view images and pdf files found in apps directory and from external folders
- Extensive customizations from custom themes to wallpapers
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

## Supported Platforms

I will release to different platforms when I feel like the app is more complete!

- [x] Android:
  - APKs in [Releases](https://github.com/RoBoT095/printnotes/releases)
  - F-Droid through [IzzyOnDroid](https://apt.izzysoft.de/fdroid/index/apk/com.printnotes.printnotes)
  - Automatically get updates from Github releases with [Obtainium](https://github.com/ImranR98/Obtainium)
  - Rejected by GooglePlay review due to the use of `MANAGE_EXTERNAL_STORAGE` permission
- [x] iOS - [App Store](https://apps.apple.com/us/app/print-notes/id6740996365)
- [ ] Windows `coming later`
- [ ] MacOS `coming later`
- [x] Linux: (mainly for testing desktop layout)
  - AppImage in [Releases](https://github.com/RoBoT095/printnotes/releases)
  - Deb in [Releases](https://github.com/RoBoT095/printnotes/releases)
  - AUR [-git](https://aur.archlinux.org/packages/printnotes-git) ([source](https://github.com/Pdzly/PrintNotesAUR), updates every Monday [![Packaging Status](https://github.com/Pdzly/PrintNotesAUR/actions/workflows/update-aur.yml/badge.svg)](https://github.com/Pdzly/PrintNotesAUR/actions/workflows/update-aur.yml)), [-bin](https://aur.archlinux.org/packages/printnotes-bin) (it install the AppImage)
  - Other options `coming later`

---

## Compiling the app

<details close>
<summary>Tap to show/hide build instructions</summary>

Make sure you have a working flutter sdk setup. If not installed, go to [Install - Flutter](https://docs.flutter.dev/get-started/install) and select your platform, and follow the instructions to make sure you have all the right dependencies installed.

Once you get everything installed, test to see you didn't miss anything:

```
flutter doctor -v
```

---

Be sure to disable signing on build.gradle or create your own keystore to [sign](https://docs.flutter.dev/deployment/android#sign-the-app) the app for android.

### Building Locally

To make sure you are running latest version of flutter, run these commands:

```
$ flutter channel stable
```

```
$ flutter upgrade
```

After that, building is as simple as running these commands:

> This is to grab app dependencies

```
$ flutter pub get
```

> This is to make sure app runs

```
$ flutter run lib/main.dart
```

> If you are unsure what target operating system, read further down

```
$ flutter build <target> --release
```

### Targets available for flutter:

- `apk`: Build an Android APK file from app.
- `appbundle`: Build an Android App Bundle file from app (used for Google Play Store).
- `aar`: Build a repository containing an AAR and a POM file.
- `bundle`: Build the Flutter assets directory from app.

### Device host specific

In other words, compiling can only be done on device you are compiling for (ex: an `.exe` requires windows)

- `linux`: Build a Linux desktop application.
- `windows`: Build a Windows desktop application.
  - Read this: https://github.com/espresso3389/pdfrx/tree/master/packages/pdfrx#note-for-windows
- `macos`: Build a MacOS desktop application.
  - `ipa`: Build an iOS App Store Package from app.

### Building with Docker

If you have docker installed you can run my script to automatically build APKs, here is how to use them:

> change into scripts directory

```
cd scripts/
```

> allow script to be executable

```
chmod +x docker-build.sh
```

> run the script

```
./docker-build.sh
```

On completion you should have an `outputs/` folder with 4 apk files (app-release, app-arm64-v8a-release, app-armeabi-v7a-release, and app-x86_64-release)

</details>

### Known Issues with Developing/Running App as Linux Application on Linux Mint

<details close>
<summary>Tap to see issue details</summary>

**<u>Note: This doesn't seem to affect other types of distros, or when running in android emulator</u>**

Running as a linux application on flutter version _3.24.0 (or newer)_ causes any `TextFields` to **slows down** or **crash** the app (ex. editing note, creating note/folder, searching, etc), best workaround currently is either disabling the "Enable the on-screen keyboard" option in Accessibilty > Keyboard, or wrapping all textfields with `ExcludeSemantics` widget, or downgrading to flutter version _3.22.3_.

</details>

## Donations & Support

Feel free to support me and my work through any of these platforms:

[![Liberapay](https://img.shields.io/badge/Liberapay-F6C915?logo=liberapay&logoColor=black)](https://liberapay.com/RoBoT_095/donate)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/robot095/donate)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/robot_095)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-3385FF?logo=open-collective&logoColor=white)](https://opencollective.com/webpack/donate)
