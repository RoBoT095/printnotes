# Print(Notes) A Better way to take Notes

**Inspired by Google Keep and Obsidian**

## Features

- Support Markdown... obviously
- Stores notes locally on device
<!-- - Supports Windows, Mac, Linux, Android, and iOS -->
- Possible to create folders to store notes in
- Has many colors to choose from
- Simple search to find any note, even the ones deeper in a folder
- Notes can be archived and soft deleted aka deleted after some time passes
- Changeable layout and sort order
- Toolbar for easy markdown editing (borrowed from [simple_markdown_editor](https://github.com/zahniar88/simple_markdown_editor))

---

## Future Features on the List

- [ ] Custom themes maker with import/export capability
- [ ] Advanced search with filters
- [ ] Tags
- [ ] Upload and attach pictures
- [ ] Share notes
- [ ] Sync options like NextCloud, Dropbox, Google Drive, RSync, FTP (possible to use SyncThing on folder where notes are stored)

## Platform

- [ ] Android `coming soon`
- [ ] iOS `coming soon`
- [ ] Windows `coming soon`
- [ ] macOS `coming soon`
- [ ] Linux `coming soon`

---

## Compiling the app

Make sure you have a working flutter sdk setup. If not installed, go to [Install - Flutter](https://docs.flutter.dev/get-started/install) and select your platform.

Be sure to disable signing on build.gradle or change keystore to sign the app.

For now the required flutter channel is master, so issue those two commands before starting building:

```
$ flutter channel master
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
