# Changelog

> Moved DevLog into separate file

## v0.10.3 - WIP

### Changes:

- Added a Dynamic Colors option to use systems colors (not supported for iOS)
- Added sketchpad that saves files as `.bson` files
- Changed file duplication increments with a number instead of adding `_copy` to name over and over.
- Added a share button on note editor (for text), and to PDF and Image viewers (to share file)

### Fixed:

- Fixed archive screen navigation breaking

## v0.10.2 - Aug 20, 2025

### Changes:

- Added a tags list that is shown in drawer
- WikiLinks can now point to and scroll to header
- Added support for `.bmp` and `.gif` to image viewer
- Brought back table of contents without breaking scrolling
- Added ability to open images, pdf files, and text files in read only mode in android from file manager

### Fixed:

- Fixed "All Notes" button... again

## v0.10.1 - Aug 4, 2025

### Changes:

- Can now link local images in notes with relative path too
- Added WiFi usage explanation page on intro page
- Added WikiLinks (link note to different note, now works with normal md links too)
- On desktop:
  - System title bars can now be hidden
  - App title bars can now be used to drag window
  - Improved centering of content on larger window sizes
- Added a lot of new customization options in settings, like adding background image and styling the note tiles, and more

### Fixed:

- In theory, optimized the loading of notes and search with multi-threading
- Fixed pdf search bar

### Removed:

- Removed table of contents list in favor of synced scroll position between edit and preview mode in note editor

## v0.10.0 - Jun 9, 2025

### Changes:

- Added ability to display local images inside markdown notes
- App now supports frontmatter to add support for md file metadata
  - Can be used to modify visible title, description (preview), background color and text color (see wiki for more details)
- Toolbar now has a table maker
- Added folder priority sorting option (display folders above or below files)
- Added CSV parser into markdown table

### Fixed:

- Opening file without making changes, would save, modifying last modified date
- Markdown syntax for highlighting and underlining would revert to default font size when inside a list
- Fixed other bugs caused when adding frontmatter support

## v0.9.16 - Apr 8, 2025

### Changes:

- Added underline markdown syntax (ex. `__text__`) instead of using html
- Note editor now check for external changes to file
- Notes are no longer saved on immediate change but every 3 seconds instead
- Added way to open pdf files on android from file manager
- Switched to using double space for indentation as tab (`\t`) breaks indents for lines underneath
- Added option to make dark mode background pure black for built in themes
- Added option to switch between different codeblock themes from Flutter Highlight library

## v0.9.15 - Feb 22, 2025

### Changes:

- Added pull to refresh for Grid/List view on mobile

### Fixed:

- Fixed drawer's "All Notes" button not redirecting to main folder
- Fixed note preview not updating changes when exiting note
- Fixed permanent delete trashing files instead of deleting
- Fixed trash and archive folders not updating when changing main folder

## v0.9.14 - Feb 14, 2025

### Changes:

- Added settings screen from Notes Editor (click the more button in top right and go to Configure)
  - Change font size for edit and view modes
  - Rearrange and show/hide markdown toolbar buttons
- Added toolbar config to json file in `.printnotes/main_config.json`
- Added button to Settings to delete and generate new json file (currently on used or custom themes and toolbar config)

> **Note:** The json file is meant for keeping some settings synced between multiple devices. Might add option to include more settings and cherry-pick which ones to store by user.

## v0.9.13 - Feb 7, 2025

### Changes:

- Added ability to select multiple files and perform bulk actions like moving or deleting (tree layout isn't supported currently)

### Fixed:

- Fixed sorting and page not reloading for tree layout
- Fixed Archive and Trash not showing their contents

## v0.9.11 - Jan 3, 2025

### Changes:

- Added PDF Viewer
- Added button to open external images and PDF files outside of notes directory located in FAB (aka floating "+" button from home screen)

## v0.9.10 - Dec 27, 2024

### Fixed:

- Fixed search and removed hidden folders being included in output

## v0.9.9 - Dec 2, 2024

### Changes:

- Made snackbars prettier

### Fixed:

- Config file for custom themes is now indented properly making it readable
- Fixed minor bugs and visual discrepancies

## v0.9.8 - Nov 19, 2024

### Changes:

- Added info pop up in note editor for word and character counts, file size, file mod date, and file path
- Made table of contents into an end drawer for desktops
- Added content centering on larger screens/desktop for:
  - Note editor
  - Image viewer
  - Settings page
  - About page
  - Custom colors page
- Added advanced search option to search through note contents
  - Advanced search now finds tags if you type `tags:` before name of tag
- Moved "sort by" button into a 3 dot "more" popup menu
- Made "change layout" into a popup menu rather than cycling through modes on select

### Fixed:

- Changed look of tags to better work in different themes
- Fixed expanded list in toolbar being white in dark mode

### Removed:

- Removed all code related to syncing from main into [syncing-dev](https://github.com/RoBoT095/printnotes/tree/syncing-dev)

## v0.9.7 - Nov 3, 2024

### Changes:

- Added basic image viewer for image files
- Added "Tree View" layout

### Removed:

- Sync screen has been removed from app and moved to a separate [branch](https://github.com/RoBoT095/printnotes/tree/syncing-dev)

## v0.9.5 - Oct 22, 2024

### Changes:

- The drawer icon is now the app logo
- Desktop got a button to hide table of contents panel, will be open by default

### Removed:

- Removed manual saving of notes into immediate save on change
  - Removed **ctrl+s** save shortcut for desktop

## v0.9.4 - Oct 20, 2024

### Changes:

- Added slider in settings to adjust note text preview amount
- Reload button now gives feedback when reloading
- Added custom themes page to create themes from [printnotes_theme_maker](https://github.com/RoBoT095/printnotes_theme_maker)
- Added button to open file location in file manager [#1](https://github.com/RoBoT095/printnotes/pull/1) (thanks [@Rooki](https://github.com/Pdzly)!)
  - Saved to a hidden json file
- Added custom `==highlighting==` markdown syntax as well as `#Tags`

### Contributors

[<img src="https://wsrv.nl/?url=github.com/Pdzly.png?w=64&h=64&mask=circle&fit=cover&maxage=1w" width="32" height="32" alt="Pdzly" />](https://github.com/Pdzly)

## v0.9.3 - Sept 29, 2024

### Changes:

- Home screen text size reduced
- Added last modified sort option
- App will prompt if not supported file is attempted to be opened
- Added option to toggle LaTeX support from settings

## v0.9.2 - Sept 26, 2024

### Changes:

- Added ability to rename from note editor screen by double tapping title
- Creating new note immediately opens it
- Added table of contents pop out on note editor screen
- Delete is now permanent by default
- Made styling changes to drawer
- Replaced markdown rendering library to `markdown_widget`

  - Code blocks are now colored if coding language specified
  - Now supports LaTeX math notions
  - Desktop supports **crtl+s** for saving and **crtl+shift+v** to switch between edit and preview mode

- Changed look on snackbar popups
- Added undo/redo buttons to note editor
- Folder icon a bit smaller with name `maxlines` increased from 1 to 2

### Fixed:

- Prevented images and links being opened from note preview in home screen

### Removed:

- Removed soft delete and bin expiration time

## v0.9.1 - Sept 20, 2024

### Changes:

- Uploaded app icons to the different platform
- Added popup with closing app with back button
- Added sync screen to drawer
- Added secure storage for sync service credentials
- Added way to upload files and folders to nextcloud manually
  - Shows last time you uploaded notes

### Fixed:

- Fixed search and sort order buttons not updating screen when pressed

## v0.9.0 - Aug 13, 2025

**Initial Commit** and technically first version I shared with friends, was also first attempt in creating an _AppImage_ file
