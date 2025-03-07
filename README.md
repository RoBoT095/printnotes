# Print(Notes) A Better way to take Notes

[![GitHub](https://img.shields.io/github/license/RoBoT095/printnotes)](https://github.com/RoBoT095/printnotes/blob/main/LICENSE)
[![IzzyOnDroid](https://img.shields.io/endpoint?url=https://apt.izzysoft.de/fdroid/api/v1/shield/com.printnotes.printnotes)](https://apt.izzysoft.de/fdroid/index/apk/com.printnotes.printnotes)
[![App Store](https://img.shields.io/badge/App_Store-0D96F6?logo=app-store&logoColor=white)](https://apps.apple.com/us/app/print-notes/id6740996365)

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

## Supported Platforms

I will release apps when I feel like the app is more complete!

- [x] Android:
  - APKs in [Releases](https://github.com/RoBoT095/printnotes/releases)
  - F-Droid through [IzzyOnDroid](https://apt.izzysoft.de/fdroid/index/apk/com.printnotes.printnotes)
  - Can't get past GooglePlay review due to the use of All File Access permission
- [x] iOS - [App Store](https://apps.apple.com/us/app/print-notes/id6740996365)
- [ ] Windows `coming later`
- [ ] MacOS `coming later`
- [x] Linux:
  - AppImage in [Releases](https://github.com/RoBoT095/printnotes/releases) (currently for testing)
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

- `aar`: Build a repository containing an AAR and a POM file.
- `apk`: Build an Android APK file from app.
- `appbundle`: Build an Android App Bundle file from app.
- `bundle`: Build the Flutter assets directory from app.

### Device host specific

In other words, compiling can only be done on device you are compiling for (ex: `app.exe` requires windows)

- `linux`: Build a Linux desktop application.
- `windows`: Build a Windows desktop application.
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

### Known issues with running app as linux application on Linux Mint

<details close>
<summary>Tap to see issue details</summary>

**<u>Note: This doesn't seem to affect other types of distros, or when running in android emulator</u>**

Running as linux application on flutter version _3.24.0-3.24.3_ causes any **TextFields** to <u>slows down</u> or <u>crash</u> the app (ex. editing note, creating note/folder, searching, etc), best workaround currently is to switch to version [3.22.3 following this link](https://docs.flutter.dev/release/upgrade#switching-to-a-specific-flutter-version) and changing all `onPopInvokedWithResult` to just `onPopInvoked` as it doesn't exist in this version, if you are still having issues, try running `flutter clean` then `flutter run lib/main.dart` again, let me know if you have any other issues or need a step-by-step guide.

</details>

## Donations & Support

Feel free to support me and my work through any of these platforms:

[![Liberapay](https://img.shields.io/badge/Liberapay-F6C915?logo=liberapay&logoColor=black)](https://liberapay.com/RoBoT_095/donate)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/robot095/donate)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/robot_095)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-3385FF?logo=open-collective&logoColor=white)](https://opencollective.com/webpack/donate)
